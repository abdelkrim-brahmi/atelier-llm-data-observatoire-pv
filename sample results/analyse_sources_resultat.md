# Data Warehouse Snowflake - Observatoire Photovoltaïque
## Conception technique pour l'observatoire stratégique

---

# 1. ANALYSE DES SOURCES DE DONNÉES

## 1.1 Source Principale : Production Régionale Annuelle par Filière

### Structure et Schéma
```sql
-- Structure détectée du fichier prodregionannuellefiliere.csv
SOURCE_SCHEMA:
├── Année                        : INTEGER (2008-2024)
├── Code INSEE région            : INTEGER (11,24,27,28,32,44,52,53,75,76,84,93,94) 
├── Région                       : VARCHAR(50) (13 régions françaises)
├── Production nucléaire (GWh)   : DECIMAL(10,2) - Valeurs nulles présentes
├── Production thermique (GWh)   : DECIMAL(10,2) - Complet
├── Production hydraulique (GWh) : DECIMAL(10,2) - Complet  
├── Production éolienne (GWh)    : DECIMAL(10,2) - Complet
├── Production solaire (GWh)     : DECIMAL(10,2) - 100% complet ✓
└── Production bioénergies (GWh) : DECIMAL(10,2) - Complet
```

### Qualité des Données - Diagnostic Détaillé

**✅ POINTS FORTS**
- **Complétude production solaire** : 100% (221/221 lignes)
- **Cohérence temporelle** : Couverture continue 2008-2024 (17 années)
- **Couverture géographique** : 13 régions françaises complètes  
- **Granularité** : Régionale/Annuelle adaptée aux analyses stratégiques
- **Volumétrie** : 221 lignes = dataset manageable

**⚠️ DÉFIS IDENTIFIÉS**
- **Valeurs nulles production nucléaire** : ~15% lignes (régions sans nucléaire)
- **Codes INSEE non-standard** : Mix anciens/nouveaux codes régions
- **Hétérogénéité temporelle** : Toutes régions pas présentes chaque année
- **Granularité limitée** : Pas de détail mensuel/départemental

**📊 STATISTIQUES PRODUCTION SOLAIRE**
- **Plage** : 0.2 GWh (Corse 2008) → 5,806 GWh (Nouvelle-Aquitaine 2024)
- **Moyenne** : 716 GWh/région/an
- **Top 5 régions 2024** : Nouvelle-Aquitaine (5,806), Occitanie (5,053), PACA (3,296)
- **Croissance observable** : Forte dynamique 2008-2024 (×1000+ pour certaines régions)

### Volumétrie et Fréquence

**VOLUMÉTRIE ACTUELLE**
- **221 lignes** × 17 ans × 13 régions = ~13KB
- **Projection 2030** : ~350 lignes (+6 ans)
- **Stockage estimé** : <1MB données brutes

**FRÉQUENCE DE MISE À JOUR**
- **Actuelle** : Annuelle (données RTE/ENEDIS)  
- **Recommandée pour l'observatoire** : Trimestrielle
- **Latence** : 2-3 mois (consolidation institutionnelle)

## 1.2 Besoins en Sources Complémentaires

**SOURCES MANQUANTES IDENTIFIÉES** (pour un observatoire complet)

1. **Installations détaillées** : ENEDIS Open Data (puissance, nombre, segment)
2. **Données mensuelles** : Production mensuelle par région  
3. **Données départementales** : Granularité infra-régionale
4. **Métadonnées techniques** : Technologies, âge du parc, rendements

---

# 2. MODÈLE DIMENSIONNEL OPTIMAL

## 2.1 Architecture en Étoile - Vue d'Ensemble

```sql
-- SCHÉMA DIMENSIONNEL SNOWFLAKE
FACT_PRODUCTION_ENERGIE (fait central)
    ↗     ↖     ↗     ↖
DIM_TEMPS  DIM_GEOGRAPHIE  DIM_FILIERE  DIM_AGREGATION
```

## 2.2 Table de Faits Centrale

```sql
-- FACT_PRODUCTION_ENERGIE : Table de faits principale
CREATE OR REPLACE TABLE DW_PV.MARTS.FACT_PRODUCTION_ENERGIE (
    -- Clés primaires et étrangères
    FACT_ID                 VARCHAR(50) PRIMARY KEY,        -- PK technique
    DATE_KEY                INTEGER NOT NULL,               -- FK vers DIM_TEMPS  
    GEOGRAPHIE_KEY          VARCHAR(20) NOT NULL,           -- FK vers DIM_GEOGRAPHIE
    FILIERE_KEY             VARCHAR(20) NOT NULL,           -- FK vers DIM_FILIERE
    AGREGATION_KEY          VARCHAR(20) NOT NULL,           -- FK vers DIM_AGREGATION
    
    -- Métriques de production (en GWh)
    PRODUCTION_GWH          DECIMAL(12,3),                  -- Production réelle
    PRODUCTION_GWH_N1       DECIMAL(12,3),                  -- Production N-1 (comparaison)
    
    -- Métriques calculées
    CROISSANCE_ANNUELLE     DECIMAL(8,4),                   -- % croissance vs N-1
    PART_REGION_NATIONALE   DECIMAL(8,4),                   -- % région vs total France
    PART_FILIERE_REGIONALE  DECIMAL(8,4),                   -- % filière vs total région
    
    -- Métriques dérivées photovoltaïque  
    PRODUCTION_TWH          DECIMAL(10,6),                  -- Production en TWh
    EQUIV_FOYERS_ALIM       INTEGER,                        -- Nb foyers équivalents
    CO2_EVITE_TONNES        DECIMAL(12,2),                  -- Tonnes CO2 évitées
    
    -- Métadonnées techniques
    DATE_MAJ                TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    SOURCE_DONNEE           VARCHAR(100),                   -- Traçabilité
    QUALITE_DONNEE          VARCHAR(20),                    -- VALIDATED/ESTIMATED/PROVISIONAL
    
    -- Contraintes et index
    CONSTRAINT FK_FACT_TEMPS FOREIGN KEY (DATE_KEY) 
        REFERENCES DW_PV.DIMENSIONS.DIM_TEMPS(DATE_KEY),
    CONSTRAINT FK_FACT_GEO FOREIGN KEY (GEOGRAPHIE_KEY) 
        REFERENCES DW_PV.DIMENSIONS.DIM_GEOGRAPHIE(GEOGRAPHIE_KEY)
);

-- Index pour performance  
CREATE INDEX IDX_FACT_PROD_DATE_GEO ON DW_PV.MARTS.FACT_PRODUCTION_ENERGIE 
    (DATE_KEY, GEOGRAPHIE_KEY, FILIERE_KEY);
```

## 2.3 Dimensions - Conception Détaillée

### DIM_TEMPS - Dimension Temporelle

```sql
CREATE OR REPLACE TABLE DW_PV.DIMENSIONS.DIM_TEMPS (
    -- Clé primaire
    DATE_KEY                INTEGER PRIMARY KEY,            -- Format YYYYMMDD
    
    -- Attributs date complète
    DATE_COMPLETE           DATE NOT NULL,                  -- Date SQL
    ANNEE                   INTEGER NOT NULL,               -- 2008-2030
    TRIMESTRE              INTEGER NOT NULL,               -- 1,2,3,4  
    MOIS                   INTEGER NOT NULL,               -- 1-12
    MOIS_NOM               VARCHAR(20),                    -- 'Janvier', 'Février'...
    SEMAINE_ANNEE          INTEGER,                        -- 1-53
    
    -- Attributs métier énergétique
    SAISON_SOLAIRE         VARCHAR(20),                    -- 'Hiver','Printemps','Été','Automne'
    PERIODE_SCOLAIRE       BOOLEAN,                        -- TRUE/FALSE (impact consommation)
    EST_ANNEE_BISSEXTILE   BOOLEAN,                        -- TRUE/FALSE
    
    -- Périodes de référence business
    ANNEE_MOBILE_12M       VARCHAR(20),                    -- 'Jan2023-Déc2023'  
    PERIODE_PPE            VARCHAR(20),                    -- 'PPE 2019-2028' selon programmation
    
    -- Métadonnées
    DATE_MAJ               TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    ACTIF                  BOOLEAN DEFAULT TRUE
);

-- Données de référence (exemple 2024)
INSERT INTO DW_PV.DIMENSIONS.DIM_TEMPS VALUES
(20240101, '2024-01-01', 2024, 1, 1, 'Janvier', 1, 'Hiver', TRUE, TRUE, 'Jan2024-Déc2024', 'PPE 2019-2028', CURRENT_TIMESTAMP, TRUE),
(20241231, '2024-12-31', 2024, 4, 12, 'Décembre', 53, 'Hiver', FALSE, TRUE, 'Jan2024-Déc2024', 'PPE 2019-2028', CURRENT_TIMESTAMP, TRUE);
```

### DIM_GEOGRAPHIE - Dimension Géographique

```sql  
CREATE OR REPLACE TABLE DW_PV.DIMENSIONS.DIM_GEOGRAPHIE (
    -- Clé primaire
    GEOGRAPHIE_KEY          VARCHAR(20) PRIMARY KEY,        -- Format: REG_XX ou DEP_XXX
    
    -- Identifiants administratifs
    CODE_INSEE_REGION       INTEGER,                        -- Code INSEE officiel région
    CODE_INSEE_DEPARTEMENT  INTEGER,                        -- Code départemental (si applicable)  
    NOM_REGION              VARCHAR(100) NOT NULL,          -- 'Nouvelle-Aquitaine'
    NOM_DEPARTEMENT         VARCHAR(100),                   -- Si granularité départementale
    
    -- Hiérarchie administrative
    NIVEAU_GEOGRAPHIQUE     VARCHAR(20) NOT NULL,           -- 'NATIONAL','REGIONAL','DEPARTEMENTAL'
    REGION_PARENT           VARCHAR(20),                    -- Pour hiérarchie
    
    -- Caractéristiques géographiques
    SUPERFICIE_KM2          DECIMAL(10,2),                  -- Superficie en km²
    POPULATION_DERNIERE     INTEGER,                        -- Population INSEE dernière année
    DENSITE_HAB_KM2         DECIMAL(8,2),                   -- Densité calculée
    
    -- Métadonnées énergétiques  
    ZONE_CLIMATIQUE         VARCHAR(20),                    -- H1/H2/H3 (RT2012)
    IRRADIATION_MOYENNE     DECIMAL(6,2),                   -- kWh/m²/an moyenne
    POTENTIEL_PV_GW         DECIMAL(8,2),                   -- Potentiel PV théorique
    
    -- Business Intelligence
    REGION_MARKETING        VARCHAR(50),                    -- Regroupement commercial
    ZONE_CONCURRENCE        VARCHAR(30),                    -- 'FORTE','MOYENNE','FAIBLE'  
    PRIORITE_DEVELOPPEMENT  INTEGER,                        -- 1=Max, 5=Min
    
    -- Géolocalisation (pour cartographie)
    LATITUDE_CENTROIDE      DECIMAL(10,6),                  -- Coordonnée lat centre
    LONGITUDE_CENTROIDE     DECIMAL(10,6),                  -- Coordonnée long centre
    
    -- Métadonnées techniques
    DATE_MAJ                TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    ACTIF                   BOOLEAN DEFAULT TRUE
);

-- Données de référence régions françaises
INSERT INTO DW_PV.DIMENSIONS.DIM_GEOGRAPHIE VALUES
('REG_75', 75, NULL, 'Nouvelle-Aquitaine', NULL, 'REGIONAL', NULL, 84061, 6026643, 71.7, 'H2', 1350, 45.2, 'Sud-Ouest', 'MOYENNE', 1, 45.85, 0.00, CURRENT_TIMESTAMP, TRUE),
('REG_76', 76, NULL, 'Occitanie', NULL, 'REGIONAL', NULL, 72724, 6154729, 84.6, 'H3', 1450, 52.8, 'Sud', 'FORTE', 1, 43.88, 2.54, CURRENT_TIMESTAMP, TRUE),
('REG_93', 93, NULL, 'Provence-Alpes-Côte d''Azur', NULL, 'REGIONAL', NULL, 31400, 5098666, 162.4, 'H3', 1580, 28.1, 'Sud-Est', 'FORTE', 2, 43.95, 6.02, CURRENT_TIMESTAMP, TRUE);
```

### DIM_FILIERE - Dimension Filière Énergétique

```sql
CREATE OR REPLACE TABLE DW_PV.DIMENSIONS.DIM_FILIERE (
    -- Clé primaire  
    FILIERE_KEY             VARCHAR(20) PRIMARY KEY,        -- 'SOLAIRE','EOLIEN','NUCLEAIRE'...
    
    -- Caractéristiques filière
    NOM_FILIERE             VARCHAR(50) NOT NULL,           -- 'Production solaire'
    CATEGORIE_ENERGIE       VARCHAR(30) NOT NULL,           -- 'RENOUVELABLE','FOSSILE','NUCLEAIRE'
    TYPE_PRODUCTION         VARCHAR(30),                    -- 'VARIABLE','PILOTABLE','SEMI_PILOTABLE'
    
    -- Attributs techniques photovoltaïque
    TECHNOLOGIE_DOMINANTE   VARCHAR(50),                    -- 'Silicium cristallin'
    FACTEUR_CHARGE_MOYEN    DECIMAL(5,2),                   -- % facteur de charge typique
    DUREE_VIE_MOYENNE       INTEGER,                        -- Années (25 ans pour PV)
    
    -- Business et stratégie
    SEGMENT_MARCHE          VARCHAR(30),                    -- 'RESIDENTIEL','TERTIAIRE','CENTRALES'
    MATURITE_TECHNOLOGIQUE  VARCHAR(20),                    -- 'MATURE','CROISSANCE','EMERGENCE'
    COMPETITIVITE_LCOE      VARCHAR(20),                    -- 'TRES_COMPETITIVE','COMPETITIVE','CHERE'
    
    -- Métadonnées réglementaires
    DISPOSITIF_SOUTIEN      VARCHAR(100),                   -- 'Obligation d''achat, Complément de rémunération'
    OBJECTIF_PPE_2028       DECIMAL(8,2),                   -- GW objectif PPE
    
    -- Couleurs et présentation (BI)
    COULEUR_GRAPHIQUE       VARCHAR(10),                    -- Code couleur hex
    ORDRE_AFFICHAGE         INTEGER,                        -- Ordre dans graphiques
    
    -- Métadonnées
    DATE_MAJ                TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    ACTIF                   BOOLEAN DEFAULT TRUE
);

-- Données de référence filières
INSERT INTO DW_PV.DIMENSIONS.DIM_FILIERE VALUES  
('SOLAIRE', 'Production solaire', 'RENOUVELABLE', 'VARIABLE', 'Silicium cristallin', 14.5, 25, 'MULTI_SEGMENT', 'MATURE', 'TRES_COMPETITIVE', 'Obligation achat + Complément rémunération', 44.0, '#FFD700', 1, CURRENT_TIMESTAMP, TRUE),
('EOLIEN', 'Production éolienne', 'RENOUVELABLE', 'VARIABLE', 'Éolien terrestre', 23.0, 20, 'CENTRALES', 'MATURE', 'COMPETITIVE', 'Complément de rémunération', 40.0, '#00BFFF', 2, CURRENT_TIMESTAMP, TRUE),
('NUCLEAIRE', 'Production nucléaire', 'NUCLEAIRE', 'PILOTABLE', 'REP 900-1450 MW', 75.0, 50, 'CENTRALES', 'MATURE', 'COMPETITIVE', 'Marché + ARENH', 61.4, '#FF6347', 6, CURRENT_TIMESTAMP, TRUE);
```

### DIM_AGREGATION - Dimension Niveau d'Agrégation

```sql
CREATE OR REPLACE TABLE DW_PV.DIMENSIONS.DIM_AGREGATION (
    -- Clé primaire
    AGREGATION_KEY          VARCHAR(20) PRIMARY KEY,        -- 'ANNUEL','TRIMESTRIEL','MENSUEL'
    
    -- Caractéristiques de l'agrégation
    NOM_AGREGATION          VARCHAR(50) NOT NULL,           -- 'Agrégation annuelle'
    PERIODICITE             VARCHAR(20) NOT NULL,           -- 'ANNUELLE','TRIMESTRIELLE','MENSUELLE'
    GRANULARITE_JOURS       INTEGER NOT NULL,               -- 365, 90, 30
    
    -- Cas d'usage métier
    USAGE