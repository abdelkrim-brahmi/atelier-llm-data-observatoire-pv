# Data Warehouse Snowflake - Conception Complète Observatoire PV
## Architecture dimensionnelle optimisée pour l'intelligence stratégique photovoltaïque

---

# 1. ANALYSE DES SOURCES DE DONNÉES

## 1.1 Source Principale : Production Régionale Annuelle par Filière

### Structure et Schéma Détecté

```sql
-- STRUCTURE FICHIER prodregionannuellefiliere.csv
SOURCE_SCHEMA_PRODUCTION_REGIONALE:
├── Année                        : INTEGER (2008-2024, 17 années)
├── Code INSEE région            : INTEGER (11,24,27,28,32,44,52,53,75,76,84,93,94)
├── Région                       : VARCHAR(50) (13 régions françaises)  
├── Production nucléaire (GWh)   : DECIMAL(10,2) - 46% NULL (régions sans nucléaire)
├── Production thermique (GWh)   : DECIMAL(10,2) - 100% complet
├── Production hydraulique (GWh) : DECIMAL(10,2) - 100% complet
├── Production éolienne (GWh)    : DECIMAL(10,2) - 98.6% complet  
├── Production solaire (GWh)     : DECIMAL(10,2) - 100% complet ⭐
└── Production bioénergies (GWh) : DECIMAL(10,2) - 99.5% complet
```

### Diagnostic Qualité - Points Critiques

**✅ EXCELLENCE PHOTOVOLTAÏQUE**
- **Complétude solaire** : 221/221 lignes (100%) - PARFAIT
- **Plage dynamique** : 0.2 GWh (Corse 2008) → 5,806 GWh (Nouvelle-Aquitaine 2024)
- **Croissance explosive** : CAGR +53.6% sur 2008-2024 = ×954 multiplication
- **Couverture géo-temporelle** : 13 régions × 17 ans = excellente granularité

**📊 MÉTRIQUES PRODUCTION SOLAIRE**
```
• Production totale France 2024: 24,804 GWh (+34% vs 2023)
• TOP 5 régions 2024: 
  1. Nouvelle-Aquitaine: 5,806 GWh (23.4% national)
  2. Occitanie: 5,053 GWh (20.4% national) 
  3. PACA: 3,296 GWh (13.3% national)
  4. Auvergne-Rhône-Alpes: 2,894 GWh (11.7% national)
  5. Grand Est: 1,685 GWh (6.8% national)
```

**⚠️ DÉFIS IDENTIFIÉS**
- **Granularité temporelle** : Annuelle uniquement (besoin mensuel business)
- **Valeurs NULL nucléaire** : 102/221 lignes (normal, certaines régions sans réacteurs)
- **Codes INSEE non-standardisés** : Mix anciens/nouveaux découpages régionaux
- **Pas de métadonnées techniques** : Absence puissance installée, nombre sites, technologies

### Volumétrie et Architecture Cible

**VOLUMÉTRIE ACTUELLE**
```
• Lignes actuelles: 221 (17 ans × 13 régions)
• Taille moyenne/ligne: ~150 bytes  
• Volume total: ~33 KB (négligeable)
• Projection 2030: +78 lignes (+6 ans)
```

**EXTRAPOLATION BUSINESS (avec sources complémentaires)**
```
• Granularité mensuelle: ×12 = 2,652 lignes/an
• Granularité départementale: ×8 = 21,216 lignes/an  
• Volume estimé 2030 (mensuel+départemental): ~550 MB
• Fréquence optimale: Mensuelle avec historique 10 ans
```

## 1.2 Sources Complémentaires Requises (Architecture Complète)

**SOURCES MANQUANTES CRITIQUES**
1. **ENEDIS Open Data** : Installations détaillées (puissance, nombre, segment)
2. **RTE eCO2mix** : Production mensuelle temps réel
3. **SDES/CGDD** : Statistiques énergétiques trimestrielles  
4. **Appels d'offres CRE** : Projets lauréats et pipeline
5. **INSEE** : Population, PIB, données socio-économiques

---

# 2. MODÈLE DIMENSIONNEL OPTIMAL

## 2.1 Architecture en Étoile - Vision Stratégique

```sql
-- SCHÉMA DIMENSIONNEL SNOWFLAKE OPTIMISÉ
                    DIM_CALENDRIER
                          |
                          |
DIM_GEOGRAPHIE ←─── FACT_PRODUCTION_ENERGIE ─→ DIM_FILIERE_ENERGIE  
                          |                          |
                          |                          |
                    DIM_SEGMENT_MARCHE         DIM_TECHNOLOGIE
                          |
                    DIM_AGREGATION_NIVEAU
```

## 2.2 Tables de Dimensions - Conception Détaillée

### DIM_CALENDRIER - Dimension Temporelle Métier

```sql
CREATE OR REPLACE TABLE DW_PV.DIMENSIONS.DIM_CALENDRIER (
    -- Clés primaires
    DATE_KEY                INTEGER PRIMARY KEY,            -- Format YYYYMMDD
    DATE_COMPLETE           DATE NOT NULL,                  -- Date SQL standard
    
    -- Hiérarchie temporelle
    ANNEE                   INTEGER NOT NULL,               -- 2008-2030
    TRIMESTRE               INTEGER NOT NULL,               -- 1,2,3,4
    MOIS                    INTEGER NOT NULL,               -- 1-12
    MOIS_NOM_FR             VARCHAR(20),                    -- 'Janvier', 'Février'...
    SEMAINE_ANNEE           INTEGER,                        -- 1-53 (ISO)
    JOUR_ANNEE              INTEGER,                        -- 1-366
    
    -- Attributs métier énergétique  
    SAISON_SOLAIRE          VARCHAR(15) NOT NULL,           -- 'Hiver','Printemps','Été','Automne'
    SAISON_PRODUCTION       VARCHAR(15),                    -- 'Haute','Moyenne','Basse' (selon irradiation)
    PERIODE_TARIFAIRE       VARCHAR(20),                    -- 'Heures_Pleines','Heures_Creuses','Weekend'
    EST_JOUR_OUVRE          BOOLEAN DEFAULT TRUE,           -- Impact consommation électrique
    
    -- Contexte réglementaire français
    PERIODE_PPE             VARCHAR(30),                    -- 'PPE_2019_2028', 'PPE_2024_2033'
    DISPOSITIF_SOUTIEN      VARCHAR(50),                    -- Évolution tarifs de rachat
    ANNEE_FISCALE           INTEGER,                        -- Année fiscale (décalée)
    
    -- Business Intelligence
    PERIODE_MOBILE_12M      VARCHAR(30),                    -- 'Jan2024_Dec2024' pour calculs glissants
    DECALAGE_SAISONNIER     INTEGER,                        -- Mois depuis début cycle solaire (Mars=1)
    COEFFICIENT_SOLAIRE     DECIMAL(5,3),                   -- Coefficient production théorique vs juillet
    
    -- Métadonnées techniques
    DATE_CREATION           TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    DATE_MAJ                TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    ACTIF                   BOOLEAN DEFAULT TRUE,
    
    -- Index et contraintes
    CONSTRAINT CK_TRIMESTRE CHECK (TRIMESTRE BETWEEN 1 AND 4),
    CONSTRAINT CK_MOIS CHECK (MOIS BETWEEN 1 AND 12)
);

-- Index pour performance requêtes temporelles
CREATE INDEX IDX_DIM_CAL_ANNEE_MOIS ON DW_PV.DIMENSIONS.DIM_CALENDRIER (ANNEE, MOIS);
CREATE INDEX IDX_DIM_CAL_SAISON ON DW_PV.DIMENSIONS.DIM_CALENDRIER (SAISON_SOLAIRE, PERIODE_PRODUCTION);
```

### DIM_GEOGRAPHIE - Dimension Territoriale Stratégique

```sql
CREATE OR REPLACE TABLE DW_PV.DIMENSIONS.DIM_GEOGRAPHIE (
    -- Clés primaires et identifiants
    GEOGRAPHIE_KEY          VARCHAR(30) PRIMARY KEY,        -- Format: REG_XX, DEP_XXX, COM_XXXXX
    CODE_INSEE_REGION       INTEGER,                        -- Code officiel INSEE région
    CODE_INSEE_DEPARTEMENT  INTEGER,                        -- Code départemental si applicable
    CODE_INSEE_COMMUNE      INTEGER,                        -- Code communal si applicable
    
    -- Hiérarchie administrative française
    NIVEAU_GEOGRAPHIQUE     VARCHAR(20) NOT NULL,           -- 'NATIONAL','REGIONAL','DEPARTEMENTAL','COMMUNAL'
    NOM_REGION              VARCHAR(60) NOT NULL,           -- 'Nouvelle-Aquitaine'
    NOM_DEPARTEMENT         VARCHAR(50),                    -- 'Gironde' si granularité départementale
    NOM_COMMUNE             VARCHAR(100),                   -- Si granularité communale
    REGION_PARENT_KEY       VARCHAR(30),                    -- FK hiérarchie (pour départements)
    
    -- Caractéristiques géographiques et démographiques
    SUPERFICIE_KM2          DECIMAL(12,2),                  -- Superficie territoire
    POPULATION_DERNIERE     INTEGER,                        -- Population INSEE dernière année disponible
    DENSITE_POPULATION      DECIMAL(8,2),                   -- Habitants/km²
    PIB_PAR_HABITANT        DECIMAL(10,2),                  -- €/hab (pouvoir d'achat)
    NOMBRE_LOGEMENTS        INTEGER,                        -- Parc logements (potentiel résidentiel)
    
    -- Potentiel énergétique et climatique
    ZONE_CLIMATIQUE_RT2012   VARCHAR(5),                    -- H1a/H1b/H1c/H2a/H2b/H2c/H2d/H3 (réglementation)
    IRRADIATION_HORIZONTALE  DECIMAL(6,2),                  -- kWh/m²/an moyenne
    IRRADIATION_OPTIMALE     DECIMAL(6,2),                  -- kWh/m²/an inclinaison/orientation optimales
    POTENTIEL_PV_THEORIQUE   DECIMAL(10,2),                 -- GW potentiel théorique maximum
    POTENTIEL_PV_EXPLOITABLE DECIMAL(10,2),                 -- GW potentiel réaliste (contraintes)
    
    -- Intelligence business et marché
    MATURITE_MARCHE_PV       VARCHAR(20),                   -- 'PIONEER','GROWTH','MATURE','SATURATED'
    ATTRACTIVITE_COMMERCIALE VARCHAR(20),                   -- 'TRES_FORTE','FORTE','MOYENNE','FAIBLE'
    NIVEAU_CONCURRENCE       VARCHAR(20),                   -- 'FAIBLE','MOYEN','FORT','TRES_FORT'
    PRIORITE_DEVELOPPEMENT   INTEGER CHECK (PRIORITE_DEVELOPPEMENT BETWEEN 1 AND 5),
    SEGMENT_CIBLE_PRIORITAIRE VARCHAR(30),                  -- 'RESIDENTIEL','TERTIAIRE','INDUSTRIEL','CENTRALES'
    
    -- Contraintes et opportunités techniques
    DENSITE_RESEAU_BT        VARCHAR(20),                   -- 'DENSE','MOYENNE','SPARSE' (facilité raccordement)
    CONTRAINTE_RACCORDEMENT  VARCHAR(30),                   -- 'AUCUNE','LEGERE','MODEREE','FORTE','BLOQUANTE'
    PRIX_FONCIER_M2          DECIMAL(8,2),                  -- €/m² moyen (impact développement centrales)
    
    -- Géolocalisation (cartographie et SIG)
    LATITUDE_CENTROIDE       DECIMAL(10,6),                 -- Coordonnée latitude centre géométrique
    LONGITUDE_CENTROIDE      DECIMAL(10,6),                 -- Coordonnée longitude centre géométrique
    GEOMETRIE_WKT            VARCHAR(MAX),                  -- Géométrie complète format Well-Known Text
    
    -- Métadonnées techniques
    SOURCE_DONNEES           VARCHAR(100),                  -- 'INSEE_2024','IGN_2024'
    DATE_DERNIERE_MAJ        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    ACTIF                    BOOLEAN DEFAULT TRUE,
    VERSION                  INTEGER DEFAULT 1,
    
    -- Contraintes métier
    CONSTRAINT FK_REGION_PARENT FOREIGN KEY (REGION_PARENT_KEY) 
        REFERENCES DW_PV.DIMENSIONS.DIM_GEOGRAPHIE(GEOGRAPHIE_KEY)
);

-- Index optimisés pour requêtes business
CREATE INDEX IDX_GEO_NIVEAU_REGION ON DW_PV.DIMENSIONS.DIM_GEOGRAPHIE (NIVEAU_GEOGRAPHIQUE, CODE_INSEE_REGION);
CREATE INDEX IDX_GEO_PRIORITE_MATURITE ON DW_PV.DIMENSIONS.DIM_GEOGRAPHIE (PRIORITE_DEVELOPPEMENT, MATURITE_MARCHE_PV);
CREATE INDEX IDX_GEO_POTENTIEL ON DW_PV.DIMENSIONS.DIM_GEOGRAPHIE (POTENTIEL_PV_EXPLOITABLE DESC);
```

### DIM_FILIERE_ENERGIE - Dimension Technologies Énergétiques

```sql
CREATE OR REPLACE TABLE DW_PV.DIMENSIONS.DIM_FILIERE_ENERGIE (
    -- Identifiants
    FILIERE_KEY             VARCHAR(30) PRIMARY KEY,        -- 'SOLAIRE_PV','EOLIEN_TERRESTRE','NUCLEAIRE'
    
    -- Classification énergétique
    NOM_FILIERE_FR          VARCHAR(60) NOT NULL,           -- 'Photovoltaïque'
    NOM_FILIERE_EN          VARCHAR(60),                    -- 'Solar Photovoltaic'  
    CATEGORIE_ENERGIE       VARCHAR(30) NOT