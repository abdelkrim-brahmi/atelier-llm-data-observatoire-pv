-- =====================================================================================
-- PIPELINE SNOWFLAKE COMPLET - OBSERVATOIRE PHOTOVOLTAÏQUE FRANCE
-- =====================================================================================
-- Version: 1.0
-- Date: 2024
-- Description: Pipeline ETL complet pour Data Warehouse photovoltaïque stratégique
-- Source: prodregionannuellefiliere.csv (RTE/ENEDIS)
-- =====================================================================================

-- =====================================================================================
-- ÉTAPE 0: INITIALISATION ET CONFIGURATION
-- =====================================================================================

-- Création des bases et schémas
CREATE DATABASE IF NOT EXISTS DW_PHOTOVOLTAIQUE
    COMMENT = 'Data Warehouse Observatoire Photovoltaïque France';

USE DATABASE DW_PHOTOVOLTAIQUE;

-- Création des schémas par couche
CREATE SCHEMA IF NOT EXISTS STAGING
    COMMENT = 'Couche de réception des données brutes';
    
CREATE SCHEMA IF NOT EXISTS DIMENSIONS  
    COMMENT = 'Tables de dimensions du modèle en étoile';
    
CREATE SCHEMA IF NOT EXISTS FACTS
    COMMENT = 'Tables de faits et métriques';
    
CREATE SCHEMA IF NOT EXISTS MARTS
    COMMENT = 'Vues métier et KPIs pour les utilisateurs finaux';
    
CREATE SCHEMA IF NOT EXISTS MONITORING
    COMMENT = 'Logs, erreurs et monitoring du pipeline';

-- Configuration optimisations
ALTER ACCOUNT SET TIMEZONE = 'Europe/Paris';

-- =====================================================================================
-- ÉTAPE 1: COUCHE STAGING (RAW DATA)
-- =====================================================================================

USE SCHEMA DW_PHOTOVOLTAIQUE.STAGING;

-- Table de staging pour les données de production régionale
CREATE OR REPLACE TABLE STG_PRODUCTION_REGIONALE_RAW (
    -- Données métier brutes (format source)
    ANNEE                           INTEGER,
    CODE_INSEE_REGION               INTEGER,
    REGION                          VARCHAR(100),
    PRODUCTION_NUCLEAIRE_GWH        DECIMAL(12,3),
    PRODUCTION_THERMIQUE_GWH        DECIMAL(12,3),
    PRODUCTION_HYDRAULIQUE_GWH      DECIMAL(12,3),
    PRODUCTION_EOLIENNE_GWH         DECIMAL(12,3),
    PRODUCTION_SOLAIRE_GWH          DECIMAL(12,3),        -- ⭐ Focus métier
    PRODUCTION_BIOENERGIES_GWH      DECIMAL(12,3),
    
    -- Colonnes techniques de traçabilité
    FICHIER_SOURCE                  VARCHAR(500),         -- Nom du fichier source
    DATE_INSERTION                  TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    DATE_TRAITEMENT                 TIMESTAMP_NTZ,
    UTILISATEUR_INSERTION           VARCHAR(100) DEFAULT CURRENT_USER(),
    NUMERO_LIGNE_FICHIER            INTEGER,              -- Position dans le fichier source
    HASH_LIGNE                      VARCHAR(64),          -- MD5 pour déduplication
    
    -- Colonnes de contrôle qualité
    STATUT_LIGNE                    VARCHAR(20) DEFAULT 'INSERTED',  -- INSERTED/PROCESSED/REJECTED/ERROR
    ERREUR_PARSING                  VARCHAR(500),         -- Messages d'erreur si problème
    SCORE_QUALITE                   INTEGER,              -- 0-100 score qualité données
    
    -- Métadonnées pour audit
    VERSION_PIPELINE                VARCHAR(20) DEFAULT '1.0',
    ENVIRONNEMENT                   VARCHAR(20) DEFAULT 'PROD'
)
COMMENT = 'Table de staging pour données production énergétique régionale brute'
DATA_RETENTION_TIME_IN_DAYS = 90;  -- Rétention 3 mois en staging

-- Index pour performance
CREATE INDEX IF NOT EXISTS IDX_STG_PROD_ANNEE_REGION 
    ON STG_PRODUCTION_REGIONALE_RAW (ANNEE, CODE_INSEE_REGION);

-- Table des rejets et erreurs
CREATE OR REPLACE TABLE STG_REJETS_DONNEES (
    ID_REJET                        INTEGER AUTOINCREMENT,
    FICHIER_SOURCE                  VARCHAR(500),
    LIGNE_REJETEE                   VARCHAR(2000),        -- Ligne complète rejetée
    RAISON_REJET                    VARCHAR(500),         -- Motif du rejet
    TYPE_ERREUR                     VARCHAR(50),          -- VALIDATION/FORMAT/CONSTRAINT
    DATE_REJET                      TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    PEUT_ETRE_REPRISE              BOOLEAN DEFAULT FALSE,
    DATE_REPRISE                    TIMESTAMP_NTZ,
    PRIMARY KEY (ID_REJET)
)
COMMENT = 'Journal des données rejetées lors du chargement';

-- =====================================================================================
-- ÉTAPE 2: COUCHE DIMENSIONNELLE
-- =====================================================================================

USE SCHEMA DW_PHOTOVOLTAIQUE.DIMENSIONS;

-- ┌─────────────────────────────────────────────────────────────────────────────────┐
-- │ DIM_CALENDRIER - Dimension temporelle métier énergétique                        │
-- └─────────────────────────────────────────────────────────────────────────────────┘

CREATE OR REPLACE TABLE DIM_CALENDRIER (
    -- Clés primaires
    DATE_KEY                        INTEGER PRIMARY KEY,     -- Format YYYYMMDD
    DATE_COMPLETE                   DATE NOT NULL,           -- Date SQL standard
    
    -- Hiérarchie temporelle
    ANNEE                           INTEGER NOT NULL,
    TRIMESTRE                       INTEGER NOT NULL,        -- 1,2,3,4
    MOIS                            INTEGER NOT NULL,        -- 1-12
    MOIS_NOM_FR                     VARCHAR(20),             -- 'Janvier', 'Février'...
    SEMAINE_ANNEE                   INTEGER,                 -- 1-53 (ISO)
    JOUR_ANNEE                      INTEGER,                 -- 1-366
    JOUR_SEMAINE                    INTEGER,                 -- 1=Lundi, 7=Dimanche
    
    -- Attributs métier énergétique
    SAISON_SOLAIRE                  VARCHAR(15) NOT NULL,    -- 'Hiver','Printemps','Été','Automne'
    SAISON_PRODUCTION               VARCHAR(15),             -- 'Haute','Moyenne','Basse'
    PERIODE_TARIFAIRE               VARCHAR(20),             -- EDF tarification
    EST_JOUR_OUVRE                  BOOLEAN DEFAULT TRUE,
    EST_JOUR_FERIE                  BOOLEAN DEFAULT FALSE,
    
    -- Contexte réglementaire français
    PERIODE_PPE                     VARCHAR(30),             -- 'PPE_2019_2028'
    ANNEE_FISCALE                   INTEGER,                 -- Année fiscale
    
    -- Business Intelligence
    PERIODE_MOBILE_12M              VARCHAR(30),             -- 'Jan2024_Dec2024'
    DECALAGE_SAISONNIER             INTEGER,                 -- Mois depuis début cycle
    COEFFICIENT_SOLAIRE             DECIMAL(5,3) DEFAULT 1.0,-- Production relative vs juillet
    
    -- Métadonnées
    DATE_CREATION                   TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    DATE_MAJ                        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    ACTIF                           BOOLEAN DEFAULT TRUE,
    
    -- Contraintes métier
    CONSTRAINT CK_TRIMESTRE CHECK (TRIMESTRE BETWEEN 1 AND 4),
    CONSTRAINT CK_MOIS CHECK (MOIS BETWEEN 1 AND 12),
    CONSTRAINT CK_COEFF_SOLAIRE CHECK (COEFFICIENT_SOLAIRE BETWEEN 0.1 AND 1.5)
)
COMMENT = 'Dimension temporelle optimisée pour analyses énergétiques photovoltaïques'
CLUSTER BY (ANNEE, MOIS);

-- ┌─────────────────────────────────────────────────────────────────────────────────┐
-- │ DIM_GEOGRAPHIE - Dimension territoriale française                               │
-- └─────────────────────────────────────────────────────────────────────────────────┘

CREATE OR REPLACE TABLE DIM_GEOGRAPHIE (
    -- Clés et identifiants
    GEOGRAPHIE_KEY                  VARCHAR(30) PRIMARY KEY, -- REG_XX, DEP_XXX
    CODE_INSEE_REGION               INTEGER,
    CODE_INSEE_DEPARTEMENT          INTEGER,
    
    -- Hiérarchie administrative
    NIVEAU_GEOGRAPHIQUE             VARCHAR(20) NOT NULL,    -- 'NATIONAL','REGIONAL','DEPARTEMENTAL'
    NOM_REGION                      VARCHAR(60) NOT NULL,
    NOM_DEPARTEMENT                 VARCHAR(50),
    REGION_PARENT_KEY               VARCHAR(30),
    
    -- Caractéristiques démographiques
    SUPERFICIE_KM2                  DECIMAL(12,2),
    POPULATION_DERNIERE             INTEGER,
    DENSITE_POPULATION              DECIMAL(8,2),            -- hab/km²
    PIB_PAR_HABITANT                DECIMAL(10,2),           -- €/hab
    NOMBRE_LOGEMENTS                INTEGER,                 -- Potentiel résidentiel
    
    -- Potentiel énergétique
    ZONE_CLIMATIQUE_RT2012          VARCHAR(5),              -- H1a,H1b,H1c,H2a,H2b,H2c,H2d,H3
    IRRADIATION_HORIZONTALE         DECIMAL(6,2),            -- kWh/m²/an
    IRRADIATION_OPTIMALE            DECIMAL(6,2),            -- kWh/m²/an inclinaison optimale
    POTENTIEL_PV_THEORIQUE          DECIMAL(10,2),           -- GW maximum théorique
    POTENTIEL_PV_EXPLOITABLE        DECIMAL(10,2),           -- GW réaliste
    
    -- Intelligence marché
    MATURITE_MARCHE_PV              VARCHAR(20),             -- 'PIONEER','GROWTH','MATURE','SATURATED'
    ATTRACTIVITE_COMMERCIALE        VARCHAR(20),             -- 'TRES_FORTE' à 'FAIBLE'
    NIVEAU_CONCURRENCE              VARCHAR(20),
    PRIORITE_DEVELOPPEMENT          INTEGER,                 -- 1-5 (1=max priorité)
    SEGMENT_CIBLE_PRIORITAIRE       VARCHAR(30),
    
    -- Contraintes techniques
    CONTRAINTE_RACCORDEMENT         VARCHAR(30),             -- 'AUCUNE' à 'BLOQUANTE'
    PRIX_FONCIER_M2                 DECIMAL(8,2),            -- €/m²
    
    -- Géolocalisation
    LATITUDE_CENTROIDE              DECIMAL(10,6),
    LONGITUDE_CENTROIDE             DECIMAL(10,6),
    
    -- Métadonnées SCD Type 1 (mise à jour sur place)
    SOURCE_DONNEES                  VARCHAR(100) DEFAULT 'INSEE_2024',
    DATE_DERNIERE_MAJ               TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    ACTIF                           BOOLEAN DEFAULT TRUE,
    VERSION                         INTEGER DEFAULT 1,
    
    -- Contraintes
    CONSTRAINT FK_REGION_PARENT FOREIGN KEY (REGION_PARENT_KEY) 
        REFERENCES DIM_GEOGRAPHIE(GEOGRAPHIE_KEY),
    CONSTRAINT CK_PRIORITE CHECK (PRIORITE_DEVELOPPEMENT BETWEEN 1 AND 5)
)
COMMENT = 'Dimension géographique France avec intelligence marché photovoltaïque'
CLUSTER BY (CODE_INSEE_REGION, NIVEAU_GEOGRAPHIQUE);

-- ┌─────────────────────────────────────────────────────────────────────────────────┐
-- │ DIM_FILIERE_ENERGIE - Technologies énergétiques                                │
-- └─────────────────────────────────────────────────────────────────────────────────┘

CREATE OR REPLACE TABLE DIM_FILIERE_ENERGIE (
    -- Identifiants
    FILIERE_KEY                     VARCHAR(30) PRIMARY KEY, -- 'SOLAIRE_PV','EOLIEN_TERRESTRE'
    
    -- Classification
    NOM_FILIERE_FR                  VARCHAR(60) NOT NULL,
    NOM_FILIERE_EN                  VARCHAR(60),
    CATEGORIE_ENERGIE               VARCHAR(30) NOT NULL,    -- 'RENOUVELABLE','FOSSILE','NUCLEAIRE'
    TYPE_PRODUCTION                 VARCHAR(30),             -- 'VARIABLE','PILOTABLE'
    
    -- Caractéristiques techniques PV
    TECHNOLOGIE_DOMINANTE           VARCHAR(60),             -- 'Silicium cristallin'
    FACTEUR_CHARGE_MOYEN            DECIMAL(5,2),            -- % France
    DUREE_VIE_MOYENNE               INTEGER,                 -- Années
    RENDEMENT_MOYEN                 DECIMAL(5,2),            -- %
    
    -- Marché et coûts
    SEGMENT_MARCHE_PRINCIPAL        VARCHAR(30),             -- 'MULTI_SEGMENT'
    MATURITE_TECHNOLOGIQUE          VARCHAR(20),             -- 'MATURE','CROISSANCE'
    COMPETITIVITE_LCOE              VARCHAR(20),             -- 'TRES_COMPETITIVE'
    COUT_MOYEN_EUR_KW               DECIMAL(8,2),            -- €/kW installé
    
    -- Réglementaire
    DISPOSITIF_SOUTIEN_PRINCIPAL    VARCHAR(100),
    OBJECTIF_PPE_2028_GW            DECIMAL(8,2),            -- GW objectif
    OBJECTIF_PPE_2035_GW            DECIMAL(8,2),            -- GW objectif long terme
    
    -- Visualisation
    COULEUR_GRAPHIQUE               VARCHAR(10),             -- Code couleur hex
    ORDRE_AFFICHAGE                 INTEGER,
    
    -- Métadonnées
    DATE_CREATION                   TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    DATE_MAJ                        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    ACTIF                           BOOLEAN DEFAULT TRUE
)
COMMENT = 'Référentiel des filières énergétiques avec focus photovoltaïque';

-- ┌─────────────────────────────────────────────────────────────────────────────────┐
-- │ DIM_SEGMENT_MARCHE - Segmentation business photovoltaïque                      │
-- └─────────────────────────────────────────────────────────────────────────────────┘

CREATE OR REPLACE TABLE DIM_SEGMENT_MARCHE (
    SEGMENT_KEY                     VARCHAR(30) PRIMARY KEY, -- 'RESIDENTIEL','TERTIAIRE','CENTRALES'
    
    -- Classification segment
    NOM_SEGMENT                     VARCHAR(50) NOT NULL,
    DESCRIPTION_DETAILLEE           VARCHAR(200),
    PLAGE_PUISSANCE_MIN_KWC         DECIMAL(8,2),            -- kWc minimum
    PLAGE_PUISSANCE_MAX_KWC         DECIMAL(8,2),            -- kWc maximum
    
    -- Caractéristiques marché
    TAILLE_MARCHE_ANNUELLE_MW       DECIMAL(10,2),           -- MW installés/an
    PRIX_MOYEN_EUR_KWC              DECIMAL(6,2),            -- €/kWc moyen
    MARGE_MOYENNE_INSTALLATEUR      DECIMAL(5,2),            -- % marge moyenne
    DUREE_AMORTISSEMENT_MOYENNE     INTEGER,                 -- Années
    
    -- Business model
    MODELE_ECONOMIQUE_PRINCIPAL     VARCHAR(30),             -- 'VENTE','AUTOCONSOMMATION','LEASING'
    TAUX_AUTOCONSOMMATION_MOYEN     DECIMAL(5,2),            -- % auto-consommé
    TARIF_RACHAT_MOYEN_EUR_KWH      DECIMAL(6,4),            -- €/kWh
    
    -- Métadonnées
    DATE_CREATION                   TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    ACTIF                           BOOLEAN DEFAULT TRUE
)
COMMENT = 'Segmentation marché photovoltaïque français par puissance et usage';

-- =====================================================================================
-- ÉTAPE 3: PEUPLEMENT DIMENSIONS (Données de référence)
-- =====================================================================================

-- Peuplement DIM_FILIERE_ENERGIE
INSERT INTO DIM_FILIERE_ENERGIE VALUES 
('SOLAIRE_PV', 'Production photovoltaïque', 'Solar Photovoltaic', 'RENOUVELABLE', 'VARIABLE', 
 'Silicium cristallin', 14.2, 25, 20.5, 'MULTI_SEGMENT', 'MATURE', 'TRES_COMPETITIVE', 1200,
 'Obligation achat + Complément rémunération', 44.5, 75.0, '#FFD700', 1, 
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE),
 
('EOLIEN_TERRESTRE', 'Production éolienne terrestre', 'Onshore Wind', 'RENOUVELABLE', 'VARIABLE',
 'Éolien terrestre 2-3MW', 23.0, 20, 45.0, 'CENTRALES', 'MATURE', 'COMPETITIVE', 1100,
 'Complément de rémunération', 40.0, 45.0, '#00BFFF', 2,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE),
 
('NUCLEAIRE', 'Production nucléaire', 'Nuclear Power', 'NUCLEAIRE', 'PILOTABLE',
 'REP 900-1450MW', 75.0, 50, 35.0, 'CENTRALES', 'MATURE', 'COMPETITIVE', 4500,
 'Marché + ARENH', 61.4, 61.4, '#FF6347', 6,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE);

-- Peuplement DIM_SEGMENT_MARCHE
INSERT INTO DIM_SEGMENT_MARCHE VALUES
('RESIDENTIEL', 'Installations résidentielles particuliers', 'Toitures maisons individuelles et petits collectifs', 
 1.0, 9.0, 1200, 2.1, 25.0, 12, 'AUTOCONSOMMATION', 65.0, 0.1317, CURRENT_TIMESTAMP, TRUE),
 
('TERTIAIRE', 'Installations tertiaires et industrielles', 'Toitures bâtiments entreprises et industries',
 9.1, 100.0, 800, 1.85, 20.0, 8, 'AUTOCONSOMMATION', 75.0, 0.1089, CURRENT_TIMESTAMP, TRUE),
 
('CENTRALES_SOL', 'Centrales photovoltaïques au sol', 'Parcs solaires et grandes installations',
 100.1, 50000.0, 2500, 0.95, 12.0, 15, 'VENTE', 0.0, 0.0847, CURRENT_TIMESTAMP, TRUE);

-- Peuplement DIM_GEOGRAPHIE (Régions françaises principales)
INSERT INTO DIM_GEOGRAPHIE (
    GEOGRAPHIE_KEY, CODE_INSEE_REGION, NIVEAU_GEOGRAPHIQUE, NOM_REGION, 
    SUPERFICIE_KM2, POPULATION_DERNIERE, ZONE_CLIMATIQUE_RT2012, IRRADIATION_HORIZONTALE, IRRADIATION_OPTIMALE,
    POTENTIEL_PV_THEORIQUE, POTENTIEL_PV_EXPLOITABLE, MATURITE_MARCHE_PV, ATTRACTIVITE_COMMERCIALE,
    PRIORITE_DEVELOPPEMENT, LATITUDE_CENTROIDE, LONGITUDE_CENTROIDE
) VALUES 
('REG_75', 75, 'REGIONAL', 'Nouvelle-Aquitaine', 84061, 6026643, 'H2', 1350, 1520, 45.2, 28.5, 'MATURE', 'TRES_FORTE', 1, 45.85, 0.00),
('REG_76', 76, 'REGIONAL', 'Occitanie', 72724, 6154729, 'H3', 1450, 1640, 52.8, 31.2, 'MATURE', 'TRES_FORTE', 1, 43.88, 2.54),
('REG_93', 93, 'REGIONAL', 'Provence-Alpes-Côte d\'Azur', 31400, 5098666, 'H3', 1580, 1780, 28.1, 18.3, 'SATURATED', 'FORTE', 2, 43.95, 6.02),
('REG_84', 84, 'REGIONAL', 'Auvergne-Rhône-Alpes', 69711, 8042936, 'H1', 1280, 1450, 38.4, 24.1, 'GROWTH', 'FORTE', 2, 45.35, 4.85),
('REG_44', 44, 'REGIONAL', 'Grand Est', 57433, 5556219, 'H1', 1180, 1340, 32.6, 20.8, 'GROWTH', 'MOYENNE', 3, 48.70, 6.18),
('REG_32', 32, 'REGIONAL', 'Hauts-de-France', 31813, 5987883, 'H1', 1050, 1190, 24.2, 15.1, 'PIONEER', 'FORTE', 1, 50.48, 2.79),
('REG_52', 52, 'REGIONAL', 'Pays de la Loire', 32082, 3832120, 'H2', 1230, 1390, 26.8, 17.2, 'GROWTH', 'MOYENNE', 3, 47.35, -1.26),
('REG_53', 53, 'REGIONAL', 'Bretagne', 27208, 3394909, 'H2', 1150, 1300, 22.1, 14.5, 'PIONEER', 'MOYENNE', 4, 48.20, -2.93),
('REG_24', 24, 'REGIONAL', 'Centre-Val de Loire', 39151, 2573180, 'H2', 1280, 1450, 28.9, 18.8, 'GROWTH', 'MOYENNE', 3, 47.50, 1.85),
('REG_28', 28, 'REGIONAL', 'Normandie', 29906, 3325032, 'H1', 1100, 1250, 23.4, 15.2, 'PIONEER', 'MOYENNE', 4, 49.18, 0.37),
('REG_27', 27, 'REGIONAL', 'Bourgogne-Franche-Comté', 47784, 2783039, 'H1', 1220, 1380, 32.1, 20.9, 'PIONEER', 'MOYENNE', 4, 47.28, 4.95),
('REG_11', 11, 'REGIONAL', 'Île-de-France', 12011, 12278210, 'H1', 1150, 1300, 8.2, 3.1, 'MATURE', 'FAIBLE', 5, 48.85, 2.35),
('REG_94', 94, 'REGIONAL', 'Corse', 8680, 344679, 'H3', 1650, 1850, 6.8, 4.2, 'PIONEER', 'FAIBLE', 5, 42.15, 9.15);

-- =====================================================================================
-- ÉTAPE 4: COUCHE FACTS - TABLE DE FAITS CENTRALE
-- =====================================================================================

USE SCHEMA DW_PHOTOVOLTAIQUE.FACTS;

-- ┌─────────────────────────────────────────────────────────────────────────────────┐
-- │ FACT_PRODUCTION_ENERGIE - Table de faits principale                            │
-- └─────────────────────────────────────────────────────────────────────────────────┘

CREATE OR REPLACE TABLE FACT_PRODUCTION_ENERGIE (
    -- Clés primaires et étrangères
    FACT_ID                         VARCHAR(50) PRIMARY KEY,  -- Clé technique composite
    DATE_KEY                        INTEGER NOT NULL,         -- FK vers DIM_CALENDRIER
    GEOGRAPHIE_KEY                  VARCHAR(30) NOT NULL,     -- FK vers DIM_GEOGRAPHIE
    FILIERE_KEY                     VARCHAR(30) NOT NULL,     -- FK vers DIM_FILIERE_ENERGIE
    SEGMENT_KEY                     VARCHAR(30),              -- FK vers DIM_SEGMENT_MARCHE
    
    -- Métriques de production énergétique (Valeurs de base)
    PRODUCTION_GWH                  DECIMAL(12,3),            -- Production réelle GWh
    PRODUCTION_GWH_N1               DECIMAL(12,3),            -- Production N-1 pour comparaison
    PRODUCTION_TWH                  DECIMAL(10,6),            -- Production TWh (calculé)
    
    -- Métriques calculées évolution
    CROISSANCE_ABSOLUE_GWH          DECIMAL(10,3),            -- Δ vs N-1 en GWh
    CROISSANCE_RELATIVE_PERCENT     DECIMAL(8,4),             -- % croissance vs N-1
    CROISSANCE_MOBILE_12M_PERCENT   DECIMAL(8,4),             -- % croissance 12M glissants
    
    -- Métriques de répartition et parts
    PART_REGION_NATIONAL_PERCENT    DECIMAL(8,4),             -- % région vs total France
    PART_FILIERE_REGIONAL_PERCENT   DECIMAL(8,4),             -- % filière vs total région
    PART_FILIERE_NATIONAL_PERCENT   DECIMAL(8,4),             -- % filière vs total France
    
    -- Métriques spécifiques photovoltaïque
    PRODUCTION_SPECIFIQUE_KWH_KWC   DECIMAL(8,2),             -- kWh/kWc (productivité)
    FACTEUR_CHARGE_PERCENT          DECIMAL(6,3),             -- % facteur de charge observé
    HEURES_EQUIVALENTES             DECIMAL(8,2),             -- Heures équivalent pleine puissance
    
    -- Métriques d'impact et contexte
    CO2_EVITE_TONNES                DECIMAL(12,2),            -- Tonnes CO2 évitées vs mix résiduel
    EQUIVALENT_FOYERS_ALIMENTES     INTEGER,                  -- Nombre foyers équivalents
    EQUIVALENT_PUISSANCE_MW         DECIMAL(10,2),            -- MW équivalent (estimation)
    
    -- Métriques économiques estimées
    CA_ESTIME_MEU                   DECIMAL(10,2),            -- Chiffre affaires estimé M€
    ECONOMIE_IMPORT_MEU             DECIMAL(8,2),             -- Économie importation M€
    
    -- Indicateurs de qualité et fiabilité
    SCORE_QUALITE_DONNEE            INTEGER,                  -- 0-100 score fiabilité
    METHODE_CALCUL                  VARCHAR(50),              -- 'MESURE','ESTIMATION','EXTRAPOLATION'
    NIVEAU_CONFIANCE                VARCHAR(20),              -- 'ELEVE','MOYEN','FAIBLE'
    
    -- Métadonnées techniques
    DATE_CREATION                   TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    DATE_MAJ                        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    UTILISATEUR_MAJ                 VARCHAR(100) DEFAULT CURRENT_USER(),
    VERSION_CALCUL                  VARCHAR(20) DEFAULT '1.0',
    SOURCE_DONNEE_PRIMAIRE          VARCHAR(100),             -- Traçabilité
    
    -- Colonnes de partitioning et clustering
    ANNEE_PARTITION                 INTEGER,                  -- Colonne de partition
    REGION_CLUSTER                  VARCHAR(30),              -- Colonne de clustering
    
    -- Contraintes d'intégrité
    CONSTRAINT FK_FACT_DATE FOREIGN KEY (DATE_KEY) 
        REFERENCES DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER(DATE_KEY),
    CONSTRAINT FK_FACT_GEO FOREIGN KEY (GEOGRAPHIE_KEY) 
        REFERENCES DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_GEOGRAPHIE(GEOGRAPHIE_KEY),
    CONSTRAINT FK_FACT_FILIERE FOREIGN KEY (FILIERE_KEY) 
        REFERENCES DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_FILIERE_ENERGIE(FILIERE_KEY),
    CONSTRAINT FK_FACT_SEGMENT FOREIGN KEY (SEGMENT_KEY) 
        REFERENCES DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_SEGMENT_MARCHE(SEGMENT_KEY),
        
    -- Contraintes métier
    CONSTRAINT CK_PRODUCTION_POSITIVE CHECK (PRODUCTION_GWH >= 0),
    CONSTRAINT CK_FACTEUR_CHARGE CHECK (FACTEUR_CHARGE_PERCENT BETWEEN 0 AND 100),
    CONSTRAINT CK_SCORE_QUALITE CHECK (SCORE_QUALITE_DONNEE BETWEEN 0 AND 100)
)
COMMENT = 'Table de faits centrale pour production énergétique avec focus photovoltaïque'
CLUSTER BY (ANNEE_PARTITION, REGION_CLUSTER, FILIERE_KEY)
PARTITION BY (ANNEE_PARTITION);

-- Index optimisés pour requêtes business
CREATE INDEX IF NOT EXISTS IDX_FACT_PROD_DATE_GEO_FILIERE 
    ON FACT_PRODUCTION_ENERGIE (DATE_KEY, GEOGRAPHIE_KEY, FILIERE_KEY);
CREATE INDEX IF NOT EXISTS IDX_FACT_PROD_SOLAIRE 
    ON FACT_PRODUCTION_ENERGIE (FILIERE_KEY, PRODUCTION_GWH DESC) 
    WHERE FILIERE_KEY = 'SOLAIRE_PV';

-- =====================================================================================
-- ÉTAPE 5: PROCÉDURES DE CHARGEMENT ETL
-- =====================================================================================

USE SCHEMA DW_PHOTOVOLTAIQUE.STAGING;

-- ┌─────────────────────────────────────────────────────────────────────────────────┐
-- │ PROCÉDURE ETL: Chargement depuis staging vers dimensions et faits              │
-- └─────────────────────────────────────────────────────────────────────────────────┘

CREATE OR REPLACE PROCEDURE SP_CHARGER_PRODUCTION_REGIONALE(
    P_FICHIER_SOURCE VARCHAR(500) DEFAULT NULL,
    P_MODE_DEBUG BOOLEAN DEFAULT FALSE
)
RETURNS STRING
LANGUAGE SQL
COMMENT = 'Procédure ETL complète: Staging → Dimensions → Facts'
AS
$
DECLARE
    V_NB_LIGNES_TRAITEES INTEGER DEFAULT 0;
    V_NB_LIGNES_REJETEES INTEGER DEFAULT 0;
    V_MESSAGE_RETOUR STRING;
    V_TIMESTAMP_DEBUT TIMESTAMP_NTZ;
    V_TIMESTAMP_FIN TIMESTAMP_NTZ;
BEGIN
    V_TIMESTAMP_DEBUT := CURRENT_TIMESTAMP();
    
    -- ==================================================================================
    -- ÉTAPE 1: Validation et nettoyage données staging
    -- ==================================================================================
    
    -- Marquage des données invalides
    UPDATE DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW
    SET STATUT_LIGNE = 'REJECTED',
        ERREUR_PARSING = 'Année manquante ou invalide'
    WHERE ANNEE IS NULL OR ANNEE < 2000 OR ANNEE > 2050;
    
    UPDATE DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW  
    SET STATUT_LIGNE = 'REJECTED',
        ERREUR_PARSING = 'Code INSEE région manquant'
    WHERE CODE_INSEE_REGION IS NULL AND STATUT_LIGNE = 'INSERTED';
    
    UPDATE DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW
    SET STATUT_LIGNE = 'REJECTED', 
        ERREUR_PARSING = 'Production solaire négative ou aberrante'
    WHERE PRODUCTION_SOLAIRE_GWH < 0 OR PRODUCTION_SOLAIRE_GWH > 50000 
    AND STATUT_LIGNE = 'INSERTED';
    
    -- Calcul score qualité
    UPDATE DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW
    SET SCORE_QUALITE = 
        CASE 
            WHEN PRODUCTION_SOLAIRE_GWH IS NULL THEN 0
            WHEN PRODUCTION_NUCLEAIRE_GWH IS NULL THEN 80  -- Normal pour certaines régions
            WHEN PRODUCTION_EOLIENNE_GWH IS NULL THEN 70
            ELSE 100
        END
    WHERE STATUT_LIGNE = 'INSERTED';
    
    -- ==================================================================================
    -- ÉTAPE 2: Mise à jour dimension calendrier (si nouvelles années)
    -- ==================================================================================
    
    INSERT INTO DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER (
        DATE_KEY, DATE_COMPLETE, ANNEE, TRIMESTRE, MOIS, MOIS_NOM_FR,
        SAISON_SOLAIRE, PERIODE_PPE, COEFFICIENT_SOLAIRE
    )
    SELECT DISTINCT
        ANNEE * 10000 + 701 AS DATE_KEY,  -- 1er juillet comme référence annuelle
        TO_DATE(ANNEE || '-07-01') AS DATE_COMPLETE,
        ANNEE,
        3 AS TRIMESTRE,  -- Juillet = T3
        7 AS MOIS,
        'Juillet' AS MOIS_NOM_FR,
        'Été' AS SAISON_SOLAIRE,
        CASE 
            WHEN ANNEE BETWEEN 2019 AND 2028 THEN 'PPE_2019_2028'
            WHEN ANNEE >= 2029 THEN 'PPE_2024_2033'
            ELSE 'HISTORIQUE'
        END AS PERIODE_PPE,
        1.0 AS COEFFICIENT_SOLAIRE  -- Juillet = référence
    FROM DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW 
    WHERE STATUT_LIGNE = 'INSERTED'
    AND ANNEE * 10000 + 701 NOT IN (
        SELECT DATE_KEY FROM DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER
    );
    
    -- ==================================================================================
    -- ÉTAPE 3: Chargement table de faits avec calculs métier
    -- ==================================================================================
    
    -- Suppression des données existantes pour retraitement complet
    DELETE FROM DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE
    WHERE DATE_KEY IN (
        SELECT DISTINCT ANNEE * 10000 + 701 
        FROM DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW 
        WHERE STATUT_LIGNE = 'INSERTED'
    );
    
    -- Insertion des faits avec calculs
    INSERT INTO DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE (
        FACT_ID,
        DATE_KEY,
        GEOGRAPHIE_KEY, 
        FILIERE_KEY,
        PRODUCTION_GWH,
        PRODUCTION_GWH_N1,
        PRODUCTION_TWH,
        CROISSANCE_ABSOLUE_GWH,
        CROISSANCE_RELATIVE_PERCENT,
        PART_REGION_NATIONAL_PERCENT,
        PART_FILIERE_REGIONAL_PERCENT,
        PRODUCTION_SPECIFIQUE_KWH_KWC,
        FACTEUR_CHARGE_PERCENT,
        HEURES_EQUIVALENTES,
        CO2_EVITE_TONNES,
        EQUIVALENT_FOYERS_ALIMENTES,
        SCORE_QUALITE_DONNEE,
        METHODE_CALCUL,
        NIVEAU_CONFIANCE,
        ANNEE_PARTITION,
        REGION_CLUSTER,
        SOURCE_DONNEE_PRIMAIRE
    )
    -- Production solaire (focus métier principal)
    SELECT 
        -- Clé composite
        STG.ANNEE || '_REG_' || STG.CODE_INSEE_REGION || '_SOLAIRE' AS FACT_ID,
        STG.ANNEE * 10000 + 701 AS DATE_KEY,
        'REG_' || STG.CODE_INSEE_REGION AS GEOGRAPHIE_KEY,
        'SOLAIRE_PV' AS FILIERE_KEY,
        
        -- Métriques de base
        STG.PRODUCTION_SOLAIRE_GWH AS PRODUCTION_GWH,
        LAG(STG.PRODUCTION_SOLAIRE_GWH, 1) 
            OVER (PARTITION BY STG.CODE_INSEE_REGION ORDER BY STG.ANNEE) AS PRODUCTION_GWH_N1,
        STG.PRODUCTION_SOLAIRE_GWH / 1000.0 AS PRODUCTION_TWH,
        
        -- Calculs évolution
        STG.PRODUCTION_SOLAIRE_GWH - LAG(STG.PRODUCTION_SOLAIRE_GWH, 1) 
            OVER (PARTITION BY STG.CODE_INSEE_REGION ORDER BY STG.ANNEE) AS CROISSANCE_ABSOLUE_GWH,
        CASE 
            WHEN LAG(STG.PRODUCTION_SOLAIRE_GWH, 1) OVER (PARTITION BY STG.CODE_INSEE_REGION ORDER BY STG.ANNEE) > 0
            THEN (STG.PRODUCTION_SOLAIRE_GWH - LAG(STG.PRODUCTION_SOLAIRE_GWH, 1) 
                  OVER (PARTITION BY STG.CODE_INSEE_REGION ORDER BY STG.ANNEE)) * 100.0 / 
                 LAG(STG.PRODUCTION_SOLAIRE_GWH, 1) OVER (PARTITION BY STG.CODE_INSEE_REGION ORDER BY STG.ANNEE)
            ELSE NULL
        END AS CROISSANCE_RELATIVE_PERCENT,
        
        -- Calculs parts de marché
        STG.PRODUCTION_SOLAIRE_GWH * 100.0 / 
            NULLIF(SUM(STG.PRODUCTION_SOLAIRE_GWH) OVER (PARTITION BY STG.ANNEE), 0) AS PART_REGION_NATIONAL_PERCENT,
        STG.PRODUCTION_SOLAIRE_GWH * 100.0 / 
            NULLIF((STG.PRODUCTION_SOLAIRE_GWH + COALESCE(STG.PRODUCTION_EOLIENNE_GWH,0) + 
                   COALESCE(STG.PRODUCTION_HYDRAULIQUE_GWH,0)), 0) AS PART_FILIERE_REGIONAL_PERCENT,
        
        -- Métriques techniques photovoltaïques (estimations)
        CASE 
            WHEN GEO.IRRADIATION_OPTIMALE > 0 
            THEN STG.PRODUCTION_SOLAIRE_GWH * 1000000 / (STG.PRODUCTION_SOLAIRE_GWH * 1000 / (GEO.IRRADIATION_OPTIMALE * 0.85))
            ELSE NULL 
        END AS PRODUCTION_SPECIFIQUE_KWH_KWC,
        
        -- Facteur de charge estimé (14% moyen France)
        CASE 
            WHEN STG.PRODUCTION_SOLAIRE_GWH > 0
            THEN LEAST(25.0, GREATEST(8.0, 14.2 * (GEO.IRRADIATION_OPTIMALE / 1400.0)))
            ELSE NULL
        END AS FACTEUR_CHARGE_PERCENT,
        
        -- Heures équivalentes 
        CASE 
            WHEN STG.PRODUCTION_SOLAIRE_GWH > 0
            THEN GEO.IRRADIATION_OPTIMALE * 0.85  -- Performance Ratio 85%
            ELSE NULL
        END AS HEURES_EQUIVALENTES,
        
        -- Impact environnemental (facteur émission 0.5 tCO2/MWh évité)
        STG.PRODUCTION_SOLAIRE_GWH * 1000 * 0.5 AS CO2_EVITE_TONNES,
        
        -- Équivalent foyers (3.5 MWh/foyer/an moyenne France)
        ROUND(STG.PRODUCTION_SOLAIRE_GWH * 1000 / 3.5) AS EQUIVALENT_FOYERS_ALIMENTES,
        
        -- Métadonnées qualité
        STG.SCORE_QUALITE,
        'MESURE_OFFICIELLE' AS METHODE_CALCUL,
        CASE 
            WHEN STG.SCORE_QUALITE >= 90 THEN 'ELEVE'
            WHEN STG.SCORE_QUALITE >= 70 THEN 'MOYEN'
            ELSE 'FAIBLE'
        END AS NIVEAU_CONFIANCE,
        
        -- Colonnes techniques
        STG.ANNEE AS ANNEE_PARTITION,
        'REG_' || STG.CODE_INSEE_REGION AS REGION_CLUSTER,
        COALESCE(P_FICHIER_SOURCE, STG.FICHIER_SOURCE) AS SOURCE_DONNEE_PRIMAIRE
        
    FROM DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW STG
    LEFT JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_GEOGRAPHIE GEO 
        ON GEO.GEOGRAPHIE_KEY = 'REG_' || STG.CODE_INSEE_REGION
    WHERE STG.STATUT_LIGNE = 'INSERTED' 
    AND STG.PRODUCTION_SOLAIRE_GWH IS NOT NULL
    
    UNION ALL
    
    -- Production éolienne (filière complémentaire)
    SELECT 
        STG.ANNEE || '_REG_' || STG.CODE_INSEE_REGION || '_EOLIEN' AS FACT_ID,
        STG.ANNEE * 10000 + 701 AS DATE_KEY,
        'REG_' || STG.CODE_INSEE_REGION AS GEOGRAPHIE_KEY,
        'EOLIEN_TERRESTRE' AS FILIERE_KEY,
        STG.PRODUCTION_EOLIENNE_GWH AS PRODUCTION_GWH,
        LAG(STG.PRODUCTION_EOLIENNE_GWH, 1) 
            OVER (PARTITION BY STG.CODE_INSEE_REGION ORDER BY STG.ANNEE) AS PRODUCTION_GWH_N1,
        STG.PRODUCTION_EOLIENNE_GWH / 1000.0 AS PRODUCTION_TWH,
        STG.PRODUCTION_EOLIENNE_GWH - LAG(STG.PRODUCTION_EOLIENNE_GWH, 1) 
            OVER (PARTITION BY STG.CODE_INSEE_REGION ORDER BY STG.ANNEE) AS CROISSANCE_ABSOLUE_GWH,
        CASE 
            WHEN LAG(STG.PRODUCTION_EOLIENNE_GWH, 1) OVER (PARTITION BY STG.CODE_INSEE_REGION ORDER BY STG.ANNEE) > 0
            THEN (STG.PRODUCTION_EOLIENNE_GWH - LAG(STG.PRODUCTION_EOLIENNE_GWH, 1) 
                  OVER (PARTITION BY STG.CODE_INSEE_REGION ORDER BY STG.ANNEE)) * 100.0 / 
                 LAG(STG.PRODUCTION_EOLIENNE_GWH, 1) OVER (PARTITION BY STG.CODE_INSEE_REGION ORDER BY STG.ANNEE)
            ELSE NULL
        END AS CROISSANCE_RELATIVE_PERCENT,
        STG.PRODUCTION_EOLIENNE_GWH * 100.0 / 
            NULLIF(SUM(STG.PRODUCTION_EOLIENNE_GWH) OVER (PARTITION BY STG.ANNEE), 0) AS PART_REGION_NATIONAL_PERCENT,
        STG.PRODUCTION_EOLIENNE_GWH * 100.0 / 
            NULLIF((STG.PRODUCTION_SOLAIRE_GWH + COALESCE(STG.PRODUCTION_EOLIENNE_GWH,0) + 
                   COALESCE(STG.PRODUCTION_HYDRAULIQUE_GWH,0)), 0) AS PART_FILIERE_REGIONAL_PERCENT,
        NULL AS PRODUCTION_SPECIFIQUE_KWH_KWC,  -- Spécifique PV
        23.0 AS FACTEUR_CHARGE_PERCENT,  -- Moyenne éolien terrestre France
        2000 AS HEURES_EQUIVALENTES,  -- Heures équivalentes éolien
        STG.PRODUCTION_EOLIENNE_GWH * 1000 * 0.5 AS CO2_EVITE_TONNES,
        ROUND(STG.PRODUCTION_EOLIENNE_GWH * 1000 / 3.5) AS EQUIVALENT_FOYERS_ALIMENTES,
        CASE WHEN STG.PRODUCTION_EOLIENNE_GWH IS NOT NULL THEN 95 ELSE 0 END AS SCORE_QUALITE_DONNEE,
        'MESURE_OFFICIELLE' AS METHODE_CALCUL,
        'ELEVE' AS NIVEAU_CONFIANCE,
        STG.ANNEE AS ANNEE_PARTITION,
        'REG_' || STG.CODE_INSEE_REGION AS REGION_CLUSTER,
        COALESCE(P_FICHIER_SOURCE, STG.FICHIER_SOURCE) AS SOURCE_DONNEE_PRIMAIRE
        
    FROM DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW STG
    WHERE STG.STATUT_LIGNE = 'INSERTED' 
    AND STG.PRODUCTION_EOLIENNE_GWH IS NOT NULL;
    
    -- Marquage des lignes traitées
    UPDATE DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW
    SET STATUT_LIGNE = 'PROCESSED',
        DATE_TRAITEMENT = CURRENT_TIMESTAMP()
    WHERE STATUT_LIGNE = 'INSERTED';
    
    -- ==================================================================================
    -- ÉTAPE 4: Calculs post-chargement (agrégations nationales)
    -- ==================================================================================
    
    -- Calcul des totaux nationaux et parts relatives
    UPDATE DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE F
    SET PART_FILIERE_NATIONAL_PERCENT = (
        SELECT F.PRODUCTION_GWH * 100.0 / NULLIF(SUM(F2.PRODUCTION_GWH), 0)
        FROM DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE F2
        WHERE F2.DATE_KEY = F.DATE_KEY AND F2.FILIERE_KEY = F.FILIERE_KEY
    )
    WHERE DATE_KEY IN (
        SELECT DISTINCT ANNEE * 10000 + 701 
        FROM DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW 
        WHERE STATUT_LIGNE = 'PROCESSED'
    );
    
    -- ==================================================================================
    -- ÉTAPE 5: Statistiques et logging
    -- ==================================================================================
    
    SELECT COUNT(*) INTO V_NB_LIGNES_TRAITEES 
    FROM DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW 
    WHERE STATUT_LIGNE = 'PROCESSED';
    
    SELECT COUNT(*) INTO V_NB_LIGNES_REJETEES
    FROM DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW 
    WHERE STATUT_LIGNE = 'REJECTED';
    
    V_TIMESTAMP_FIN := CURRENT_TIMESTAMP();
    
    -- Log d'exécution
    INSERT INTO DW_PHOTOVOLTAIQUE.MONITORING.LOG_EXECUTION (
        PROCEDURE_NAME, FICHIER_SOURCE, NB_LIGNES_TRAITEES, NB_LIGNES_REJETEES,
        TIMESTAMP_DEBUT, TIMESTAMP_FIN, DUREE_SECONDES, STATUT
    ) VALUES (
        'SP_CHARGER_PRODUCTION_REGIONALE',
        COALESCE(P_FICHIER_SOURCE, 'AUTO'),
        V_NB_LIGNES_TRAITEES,
        V_NB_LIGNES_REJETEES,
        V_TIMESTAMP_DEBUT,
        V_TIMESTAMP_FIN,
        DATEDIFF('SECOND', V_TIMESTAMP_DEBUT, V_TIMESTAMP_FIN),
        'SUCCESS'
    );
    
    V_MESSAGE_RETOUR := 'SUCCESS - Traité: ' || V_NB_LIGNES_TRAITEES || 
                        ' lignes, Rejeté: ' || V_NB_LIGNES_REJETEES || 
                        ' lignes en ' || DATEDIFF('SECOND', V_TIMESTAMP_DEBUT, V_TIMESTAMP_FIN) || 's';
    
    RETURN V_MESSAGE_RETOUR;
    
EXCEPTION
    WHEN OTHER THEN
        -- Gestion d'erreur
        INSERT INTO DW_PHOTOVOLTAIQUE.MONITORING.LOG_EXECUTION (
            PROCEDURE_NAME, FICHIER_SOURCE, NB_LIGNES_TRAITEES, NB_LIGNES_REJETEES,
            TIMESTAMP_DEBUT, TIMESTAMP_FIN, STATUT, MESSAGE_ERREUR
        ) VALUES (
            'SP_CHARGER_PRODUCTION_REGIONALE',
            COALESCE(P_FICHIER_SOURCE, 'AUTO'),
            V_NB_LIGNES_TRAITEES,
            V_NB_LIGNES_REJETEES,
            V_TIMESTAMP_DEBUT,
            CURRENT_TIMESTAMP(),
            'ERROR',
            SQLERRM
        );
        
        RETURN 'ERROR: ' || SQLERRM;
END;
$;

-- =====================================================================================
-- ÉTAPE 6: COUCHE MARTS - VUES MÉTIER POUR LES 5 KPIS PRIORITAIRES
-- =====================================================================================

USE SCHEMA DW_PHOTOVOLTAIQUE.MARTS;

-- ┌─────────────────────────────────────────────────────────────────────────────────┐
-- │ KPI 1: PUISSANCE TOTALE INSTALLÉE (estimée depuis production)                  │
-- └─────────────────────────────────────────────────────────────────────────────────┘

CREATE OR REPLACE VIEW VW_KPI_PUISSANCE_TOTALE_INSTALLEE
COMMENT = 'KPI P0: Puissance photovoltaïque installée par région et évolution'
AS
SELECT 
    -- Dimensions
    CAL.ANNEE,
    GEO.NOM_REGION,
    GEO.CODE_INSEE_REGION,
    GEO.NIVEAU_GEOGRAPHIQUE,
    
    -- Métriques principales
    ROUND(F.PRODUCTION_GWH / (GEO.IRRADIATION_OPTIMALE * 0.85 / 1000), 2) AS PUISSANCE_ESTIMEE_MW,
    ROUND(F.PRODUCTION_GWH / (GEO.IRRADIATION_OPTIMALE * 0.85 / 1000) / 1000, 3) AS PUISSANCE_ESTIMEE_GW,
    F.PRODUCTION_GWH AS PRODUCTION_ANNUELLE_GWH,
    
    -- Évolutions
    F.CROISSANCE_RELATIVE_PERCENT AS CROISSANCE_ANNUELLE_PERCENT,
    F.CROISSANCE_ABSOLUE_GWH AS CROISSANCE_ABSOLUE_GWH,
    
    -- Parts et contexte
    F.PART_REGION_NATIONAL_PERCENT,
    ROUND(F.PRODUCTION_GWH / NULLIF(GEO.POPULATION_DERNIERE, 0) * 1000000, 1) AS PRODUCTION_KWH_PAR_HABITANT,
    ROUND((F.PRODUCTION_GWH / (GEO.IRRADIATION_OPTIMALE * 0.85 / 1000)) / NULLIF(GEO.POPULATION_DERNIERE, 0) * 1000000, 0) AS WATTS_PAR_HABITANT,
    
    -- Potentiel et maturité
    GEO.POTENTIEL_PV_EXPLOITABLE AS POTENTIEL_MAX_GW,
    ROUND((F.PRODUCTION_GWH / (GEO.IRRADIATION_OPTIMALE * 0.85 / 1000) / 1000) / NULLIF(GEO.POTENTIEL_PV_EXPLOITABLE, 0) * 100, 1) AS TAUX_SATURATION_PERCENT,
    GEO.MATURITE_MARCHE_PV,
    
    -- Métadonnées
    F.SCORE_QUALITE_DONNEE,
    F.DATE_MAJ,
    'Estimation basée sur production/irradiation' AS METHODE_CALCUL
    
FROM DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE F
JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER CAL ON F.DATE_KEY = CAL.DATE_KEY
JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_GEOGRAPHIE GEO ON F.GEOGRAPHIE_KEY = GEO.GEOGRAPHIE_KEY
WHERE F.FILIERE_KEY = 'SOLAIRE_PV'
AND GEO.NIVEAU_GEOGRAPHIQUE = 'REGIONAL'
ORDER BY CAL.ANNEE DESC, F.PRODUCTION_GWH DESC;

-- ┌─────────────────────────────────────────────────────────────────────────────────┐
-- │ KPI 2: CROISSANCE MENSUELLE DE LA PUISSANCE                                    │
-- └─────────────────────────────────────────────────────────────────────────────────┘

CREATE OR REPLACE VIEW VW_KPI_CROISSANCE_PUISSANCE
COMMENT = 'KPI P0: Évolution de la croissance photovoltaïque France'
AS
WITH CROISSANCE_NATIONALE AS (
    SELECT 
        CAL.ANNEE,
        SUM(F.PRODUCTION_GWH) AS PRODUCTION_NATIONALE_GWH,
        SUM(F.PRODUCTION_GWH / (GEO.IRRADIATION_OPTIMALE * 0.85 / 1000) / 1000) AS PUISSANCE_NATIONALE_GW,
        LAG(SUM(F.PRODUCTION_GWH / (GEO.IRRADIATION_OPTIMALE * 0.85 / 1000) / 1000), 1) 
            OVER (ORDER BY CAL.ANNEE) AS PUISSANCE_NATIONALE_GW_N1
    FROM DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE F
    JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER CAL ON F.DATE_KEY = CAL.DATE_KEY  
    JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_GEOGRAPHIE GEO ON F.GEOGRAPHIE_KEY = GEO.GEOGRAPHIE_KEY
    WHERE F.FILIERE_KEY = 'SOLAIRE_PV' 
    AND GEO.NIVEAU_GEOGRAPHIQUE = 'REGIONAL'
    GROUP BY CAL.ANNEE
)
SELECT 
    ANNEE,
    ROUND(PUISSANCE_NATIONALE_GW, 2) AS PUISSANCE_INSTALLEE_GW,
    ROUND(PUISSANCE_NATIONALE_GW - PUISSANCE_NATIONALE_GW_N1, 2) AS CROISSANCE_ABSOLUE_GW,
    ROUND((PUISSANCE_NATIONALE_GW - PUISSANCE_NATIONALE_GW_N1) / NULLIF(PUISSANCE_NATIONALE_GW_N1, 0) * 100, 1) AS CROISSANCE_RELATIVE_PERCENT,
    ROUND(PRODUCTION_NATIONALE_GWH / 1000, 2) AS PRODUCTION_NATIONALE_TWH,
    
    -- Objectifs PPE et benchmark
    CASE WHEN ANNEE = 2024 THEN 28.2 WHEN ANNEE = 2028 THEN 44.5 ELSE NULL END AS OBJECTIF_PPE_GW,
    CASE 
        WHEN ANNEE = 2024 THEN ROUND(PUISSANCE_NATIONALE_GW / 28.2 * 100, 1)
        WHEN ANNEE = 2028 THEN ROUND(PUISSANCE_NATIONALE_GW / 44.5 * 100, 1)
        ELSE NULL 
    END AS AVANCEMENT_OBJECTIF_PERCENT,
    
    -- Rythme de développement nécessaire  
    CASE 
        WHEN ANNEE >= 2024 THEN ROUND((44.5 - PUISSANCE_NATIONALE_GW) / NULLIF(2028 - ANNEE, 0), 2)
        ELSE NULL
    END AS RYTHME_REQUIS_GW_PAR_AN,
    
    -- Contexte européen (estimation)
    ROUND(PUISSANCE_NATIONALE_GW / 200.0 * 100, 1) AS PART_EUROPE_PERCENT,  -- ~200GW Europe estimé
    
    -- Métadonnées
    CURRENT_TIMESTAMP() AS DATE_CALCUL,
    'Agrégation nationale annuelle' AS METHODE
    
FROM CROISSANCE_NATIONALE
WHERE PUISSANCE_NATIONALE_GW_N1 IS NOT NULL  -- Exclut la première année sans N-1
ORDER BY ANNEE DESC;

-- ┌─────────────────────────────────────────────────────────────────────────────────┐
-- │ KPI 3: PRODUCTION TOTALE ANNUELLE                                              │
-- └─────────────────────────────────────────────────────────────────────────────────┘

CREATE OR REPLACE VIEW VW_KPI_PRODUCTION_TOTALE
COMMENT = 'KPI P0: Production photovoltaïque nationale et contexte énergétique'
AS
WITH PRODUCTION_AGREGEE AS (
    SELECT 
        CAL.ANNEE,
        SUM(CASE WHEN F.FILIERE_KEY = 'SOLAIRE_PV' THEN F.PRODUCTION_GWH ELSE 0 END) AS PROD_SOLAIRE_GWH,
        SUM(CASE WHEN F.FILIERE_KEY = 'EOLIEN_TERRESTRE' THEN F.PRODUCTION_GWH ELSE 0 END) AS PROD_EOLIEN_GWH,
        SUM(CASE WHEN F.FILIERE_KEY = 'NUCLEAIRE' THEN F.PRODUCTION_GWH ELSE 0 END) AS PROD_NUCLEAIRE_GWH,
        SUM(F.PRODUCTION_GWH) AS PROD_TOTALE_GWH
    FROM DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE F
    JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER CAL ON F.DATE_KEY = CAL.DATE_KEY
    JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_GEOGRAPHIE GEO ON F.GEOGRAPHIE_KEY = GEO.GEOGRAPHIE_KEY  
    WHERE GEO.NIVEAU_GEOGRAPHIQUE = 'REGIONAL'
    GROUP BY CAL.ANNEE
)
SELECT 
    ANNEE,
    
    -- Production photovoltaïque
    ROUND(PROD_SOLAIRE_GWH, 0) AS PRODUCTION_PV_GWH,
    ROUND(PROD_SOLAIRE_GWH / 1000, 2) AS PRODUCTION_PV_TWH,
    ROUND((PROD_SOLAIRE_GWH - LAG(PROD_SOLAIRE_GWH, 1) OVER (ORDER BY ANNEE)) / 
          NULLIF(LAG(PROD_SOLAIRE_GWH, 1) OVER (ORDER BY ANNEE), 0) * 100, 1) AS CROISSANCE_PROD_PV_PERCENT,
    
    -- Contexte mix énergétique
    ROUND(PROD_EOLIEN_GWH, 0) AS PRODUCTION_EOLIEN_GWH,
    ROUND(PROD_NUCLEAIRE_GWH, 0) AS PRODUCTION_NUCLEAIRE_GWH,
    ROUND(PROD_TOTALE_GWH, 0) AS PRODUCTION_TOTALE_GWH,
    
    -- Parts dans le mix
    ROUND(PROD_SOLAIRE_GWH / NULLIF(PROD_TOTALE_GWH, 0) * 100, 2) AS PART_PV_MIX_PERCENT,
    ROUND((PROD_SOLAIRE_GWH + PROD_EOLIEN_GWH) / NULLIF(PROD_TOTALE_GWH, 0) * 100, 2) AS PART_ENR_VARIABLES_PERCENT,
    
    -- Impact environnemental
    ROUND(PROD_SOLAIRE_GWH * 1000 * 0.5 / 1000000, 2) AS CO2_EVITE_MILLIONS_TONNES,
    ROUND(PROD_SOLAIRE_GWH * 1000 / 3.5 / 1000000, 2) AS MILLIONS_FOYERS_ALIMENTES,
    
    -- Benchmark consommation (estimation 450 TWh consommation France)
    ROUND(PROD_SOLAIRE_GWH / 450000 * 100, 2) AS COUVERTURE_CONSOMMATION_PERCENT,
    
    -- Saisonnalité (estimation été/hiver)
    ROUND(PROD_SOLAIRE_GWH * 0.35, 0) AS ESTIMATION_PROD_ETE_GWH,
    ROUND(PROD_SOLAIRE_GWH * 0.15, 0) AS ESTIMATION_PROD_HIVER_GWH,
    
    -- Métadonnées
    CURRENT_TIMESTAMP() AS DATE_CALCUL,
    'Agrégation toutes régions' AS METHODE_CALCUL
    
FROM PRODUCTION_AGREGEE
WHERE PROD_SOLAIRE_GWH > 0
ORDER BY ANNEE DESC;

-- ┌─────────────────────────────────────────────────────────────────────────────────┐
-- │ KPI 4: FACTEUR DE CHARGE MOYEN NATIONAL                                        │
-- └─────────────────────────────────────────────────────────────────────────────────┘

CREATE OR REPLACE VIEW VW_KPI_FACTEUR_CHARGE
COMMENT = 'KPI P0: Performance technique du parc photovoltaïque français'
AS
WITH PERFORMANCE_REGIONALE AS (
    SELECT 
        CAL.ANNEE,
        GEO.NOM_REGION,
        F.PRODUCTION_GWH,
        F.FACTEUR_CHARGE_PERCENT,
        F.HEURES_EQUIVALENTES,
        F.PRODUCTION_SPECIFIQUE_KWH_KWC,
        GEO.IRRADIATION_OPTIMALE,
        GEO.ZONE_CLIMATIQUE_RT2012,
        
        -- Puissance estimée
        F.PRODUCTION_GWH / (GEO.IRRADIATION_OPTIMALE * 0.85 / 1000) AS PUISSANCE_ESTIMEE_MW,
        
        -- Performance vs théorique
        F.PRODUCTION_GWH * 1000 / NULLIF((F.PRODUCTION_GWH / (GEO.IRRADIATION_OPTIMALE * 0.85 / 1000) * GEO.IRRADIATION_OPTIMALE), 0) * 100 AS PERFORMANCE_RATIO_PERCENT
        
    FROM DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE F
    JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER CAL ON F.DATE_KEY = CAL.DATE_KEY
    JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_GEOGRAPHIE GEO ON F.GEOGRAPHIE_KEY = GEO.GEOGRAPHIE_KEY
    WHERE F.FILIERE_KEY = 'SOLAIRE_PV'
    AND GEO.NIVEAU_GEOGRAPHIQUE = 'REGIONAL'
    AND F.PRODUCTION_GWH > 0
)
SELECT 
    ANNEE,
    
    -- Facteurs de charge nationaux
    ROUND(AVG(FACTEUR_CHARGE_PERCENT), 2) AS FACTEUR_CHARGE_MOYEN_PERCENT,
    ROUND(MIN(FACTEUR_CHARGE_PERCENT), 2) AS FACTEUR_CHARGE_MIN_PERCENT,
    ROUND(MAX(FACTEUR_CHARGE_PERCENT), 2) AS FACTEUR_CHARGE_MAX_PERCENT,
    ROUND(STDDEV(FACTEUR_CHARGE_PERCENT), 2) AS ECART_TYPE_FC_PERCENT,
    
    -- Productivité spécifique moyenne pondérée
    ROUND(SUM(PRODUCTION_SPECIFIQUE_KWH_KWC * PUISSANCE_ESTIMEE_MW) / NULLIF(SUM(PUISSANCE_ESTIMEE_MW), 0), 0) AS PRODUCTIVITE_PONDEREE_KWH_KWC,
    
    -- Heures équivalentes moyennes pondérées
    ROUND(SUM(HEURES_EQUIVALENTES * PUISSANCE_ESTIMEE_MW) / NULLIF(SUM(PUISSANCE_ESTIMEE_MW), 0), 0) AS HEURES_EQUIV_PONDEREES,
    
    -- Performance technique globale
    ROUND(AVG(PERFORMANCE_RATIO_PERCENT), 1) AS PERFORMANCE_RATIO_MOYEN_PERCENT,
    
    -- Disparités régionales
    MAX(NOM_REGION) KEEP (DENSE_RANK FIRST ORDER BY FACTEUR_CHARGE_PERCENT DESC) AS REGION_MEILLEURE_PERFORMANCE,
    MAX(FACTEUR_CHARGE_PERCENT) AS FACTEUR_CHARGE_BEST_PERCENT,
    MAX(NOM_REGION) KEEP (DENSE_RANK FIRST ORDER BY FACTEUR_CHARGE_PERCENT ASC) AS REGION_PLUS_FAIBLE_PERFORMANCE,
    MIN(FACTEUR_CHARGE_PERCENT) AS FACTEUR_CHARGE_WORST_PERCENT,
    
    -- Évolution vs année précédente
    ROUND(AVG(FACTEUR_CHARGE_PERCENT) - LAG(AVG(FACTEUR_CHARGE_PERCENT), 1) OVER (ORDER BY ANNEE), 2) AS EVOLUTION_FC_POINTS,
    
    -- Contexte climatique
    ROUND(AVG(IRRADIATION_OPTIMALE), 0) AS IRRADIATION_MOYENNE_KWH_M2,
    
    -- Benchmark objectifs (14% objectif moyen France)
    CASE 
        WHEN AVG(FACTEUR_CHARGE_PERCENT) >= 14.0 THEN 'OBJECTIF_ATTEINT'
        WHEN AVG(FACTEUR_CHARGE_PERCENT) >= 12.0 THEN 'PROCHE_OBJECTIF' 
        ELSE 'SOUS_OBJECTIF'
    END AS STATUT_VS_OBJECTIF,
    
    -- Métadonnées
    COUNT(*) AS NB_REGIONS_ANALYSEES,
    ROUND(SUM(PUISSANCE_ESTIMEE_MW) / 1000, 2) AS PUISSANCE_TOTALE_ANALYSEE_GW,
    CURRENT_TIMESTAMP() AS DATE_CALCUL
    
FROM PERFORMANCE_REGIONALE
GROUP BY ANNEE
ORDER BY ANNEE DESC;

-- ┌─────────────────────────────────────────────────────────────────────────────────┐
-- │ KPI 5: PUISSANCE PAR HABITANT (Densité territoriale)                          │
-- └─────────────────────────────────────────────────────────────────────────────────┘

CREATE OR REPLACE VIEW VW_KPI_PUISSANCE_PAR_HABITANT  
COMMENT = 'KPI P0: Pénétration photovoltaïque par habitant et territoire'
AS
WITH DENSITE_REGIONALE AS (
    SELECT 
        CAL.ANNEE,
        GEO.NOM_REGION,
        GEO.CODE_INSEE_REGION,
        F.PRODUCTION_GWH,
        GEO.POPULATION_DERNIERE,
        GEO.SUPERFICIE_KM2,
        GEO.DENSITE_POPULATION,
        GEO.PIB_PAR_HABITANT,
        GEO.MATURITE_MARCHE_PV,
        GEO.POTENTIEL_PV_EXPLOITABLE,
        
        -- Puissance estimée
        F.PRODUCTION_GWH / (GEO.IRRADIATION_OPTIMALE * 0.85 / 1000) AS PUISSANCE_MW,
        
        -- Densités calculées
        F.PRODUCTION_GWH / (GEO.IRRADIATION_OPTIMALE * 0.85 / 1000) / NULLIF(GEO.POPULATION_DERNIERE, 0) * 1000000 AS WATTS_PAR_HABITANT,
        F.PRODUCTION_GWH / (GEO.IRRADIATION_OPTIMALE * 0.85 / 1000) / NULLIF(GEO.SUPERFICIE_KM2, 0) AS MW_PAR_KM2,
        F.PRODUCTION_GWH * 1000 / NULLIF(GEO.POPULATION_DERNIERE, 0) AS KWH_PAR_HABITANT,
        
        -- Taux de saturation du potentiel
        (F.PRODUCTION_GWH / (GEO.IRRADIATION_OPTIMALE * 0.85 / 1000) / 1000) / NULLIF(GEO.POTENTIEL_PV_EXPLOITABLE, 0) * 100 AS TAUX_SATURATION_PERCENT
        
    FROM DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE F
    JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER CAL ON F.DATE_KEY = CAL.DATE_KEY
    JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_GEOGRAPHIE GEO ON F.GEOGRAPHIE_KEY = GEO.GEOGRAPHIE_KEY
    WHERE F.FILIERE_KEY = 'SOLAIRE_PV'
    AND GEO.NIVEAU_GEOGRAPHIQUE = 'REGIONAL'
    AND F.PRODUCTION_GWH > 0
    AND GEO.POPULATION_DERNIERE > 0
)
SELECT 
    ANNEE,
    NOM_REGION,
    
    -- Métriques principales de densité  
    ROUND(WATTS_PAR_HABITANT, 0) AS WATTS_PAR_HABITANT,
    ROUND(KWH_PAR_HABITANT, 0) AS KWH_PROD_PAR_HABITANT,
    ROUND(MW_PAR_KM2, 2) AS MW_PAR_KM2,
    ROUND(PUISSANCE_MW, 0) AS PUISSANCE_TOTALE_MW,
    
    -- Classements et benchmarks
    RANK() OVER (PARTITION BY ANNEE ORDER BY WATTS_PAR_HABITANT DESC) AS RANG_NATIONAL_W_PAR_HAB,
    RANK() OVER (PARTITION BY ANNEE ORDER BY MW_PAR_KM2 DESC) AS RANG_NATIONAL_DENSITE_GEO,
    
    -- Contexte démographique et économique
    POPULATION_DERNIERE AS POPULATION,
    ROUND(DENSITE_POPULATION, 1) AS DENSITE_POPULATION_HAB_KM2,
    PIB_PAR_HABITANT AS PIB_PAR_HABITANT_EUR,
    
    -- Potentiel et maturité
    ROUND(TAUX_SATURATION_PERCENT, 1) AS TAUX_SATURATION_POTENTIEL_PERCENT,
    MATURITE_MARCHE_PV,
    ROUND(POTENTIEL_PV_EXPLOITABLE * 1000, 0) AS POTENTIEL_RESIDUEL_MW,
    
    -- Catégorisation performance
    CASE 
        WHEN WATTS_PAR_HABITANT >= 400 THEN 'LEADER'
        WHEN WATTS_PAR_HABITANT >= 200 THEN 'DEVELOPPE' 
        WHEN WATTS_PAR_HABITANT >= 100 THEN 'CROISSANCE'
        ELSE 'POTENTIEL_INEXPLOITE'
    END AS CATEGORIE_MATURITE,
    
    -- Évolution vs année précédente
    ROUND(WATTS_PAR_HABITANT - LAG(WATTS_PAR_HABITANT, 1) 
          OVER (PARTITION BY CODE_INSEE_REGION ORDER BY ANNEE), 0) AS EVOLUTION_W_PAR_HAB,
    ROUND((WATTS_PAR_HABITANT - LAG(WATTS_PAR_HABITANT, 1) 
          OVER (PARTITION BY CODE_INSEE_REGION ORDER BY ANNEE)) / 
          NULLIF(LAG(WATTS_PAR_HABITANT, 1) OVER (PARTITION BY CODE_INSEE_REGION ORDER BY ANNEE), 0) * 100, 1) AS EVOLUTION_W_PAR_HAB_PERCENT,
          
    -- Benchmark national moyen
    ROUND(AVG(WATTS_PAR_HABITANT) OVER (PARTITION BY ANNEE), 0) AS MOYENNE_NATIONALE_W_PAR_HAB,
    ROUND((WATTS_PAR_HABITANT / NULLIF(AVG(WATTS_PAR_HABITANT) OVER (PARTITION BY ANNEE), 0) - 1) * 100, 1) AS ECART_MOYENNE_NATIONALE_PERCENT,
    
    -- Métadonnées
    CURRENT_TIMESTAMP() AS DATE_CALCUL,
    'Calcul basé sur production/irradiation et population INSEE' AS METHODE
    
FROM DENSITE_REGIONALE
ORDER BY ANNEE DESC, WATTS_PAR_HABITANT DESC;

-- =====================================================================================
-- ÉTAPE 7: VUES D'AGRÉGATION MULTI-NIVEAUX
-- =====================================================================================

-- Vue synthèse nationale annuelle
CREATE OR REPLACE VIEW VW_SYNTHESE_NATIONALE_ANNUELLE
COMMENT = 'Vue de synthèse pour tableau de bord exécutif'
AS
SELECT 
    KC.ANNEE,
    KC.PUISSANCE_INSTALLEE_GW,
    KC.CROISSANCE_RELATIVE_PERCENT AS CROISSANCE_PUISSANCE_PERCENT,
    KC.AVANCEMENT_OBJECTIF_PERCENT AS AVANCEMENT_PPE_PERCENT,
    
    KP.PRODUCTION_PV_TWH,
    KP.PART_PV_MIX_PERCENT,
    KP.COUVERTURE_CONSOMMATION_PERCENT,
    
    KF.FACTEUR_CHARGE_MOYEN_PERCENT,
    KF.PRODUCTIVITE_PONDEREE_KWH_KWC,
    KF.REGION_MEILLEURE_PERFORMANCE,
    
    KD.MOYENNE_NATIONALE_W_PAR_HAB,
    
    -- Alertes et insights
    CASE 
        WHEN KC.CROISSANCE_RELATIVE_PERCENT > 50 THEN 'ACCELERATION_FORTE'
        WHEN KC.CROISSANCE_RELATIVE_PERCENT > 20 THEN 'CROISSANCE_SOUTENUE'
        WHEN KC.CROISSANCE_RELATIVE_PERCENT > 10 THEN 'CROISSANCE_NORMALE'
        ELSE 'RALENTISSEMENT'
    END AS ALERTE_CROISSANCE,
    
    CASE 
        WHEN KC.AVANCEMENT_OBJECTIF_PERCENT >= 90 THEN 'OBJECTIF_EN_VOIE'
        WHEN KC.AVANCEMENT_OBJECTIF_PERCENT >= 70 THEN 'TRAJECTOIRE_CORRECTE'
        ELSE 'EFFORT_SUPPLEMENTAIRE_REQUIS'
    END AS STATUT_PPE,
    
    CURRENT_TIMESTAMP() AS DATE_MAJ
    
FROM VW_KPI_CROISSANCE_PUISSANCE KC
LEFT JOIN VW_KPI_PRODUCTION_TOTALE KP ON KC.ANNEE = KP.ANNEE  
LEFT JOIN VW_KPI_FACTEUR_CHARGE KF ON KC.ANNEE = KF.ANNEE
LEFT JOIN (SELECT ANNEE, AVG(WATTS_PAR_HABITANT) AS MOYENNE_NATIONALE_W_PAR_HAB 
          FROM VW_KPI_PUISSANCE_PAR_HABITANT GROUP BY ANNEE) KD ON KC.ANNEE = KD.ANNEE
ORDER BY KC.ANNEE DESC;

-- Vue top/flop régions avec recommandations
CREATE OR REPLACE VIEW VW_OPPORTUNITES_REGIONALES
COMMENT = 'Analyse des opportunités de développement par région'
AS  
WITH DERNIERE_ANNEE AS (
    SELECT MAX(ANNEE) AS ANNEE_REF FROM VW_KPI_PUISSANCE_PAR_HABITANT
),
ANALYSE_REGIONALE AS (
    SELECT 
        KD.NOM_REGION,
        KD.WATTS_PAR_HABITANT,
        KD.RANG_NATIONAL_W_PAR_HAB,
        KD.TAUX_SATURATION_POTENTIEL_PERCENT,
        KD.EVOLUTION_W_PAR_HAB_PERCENT,
        KD.POTENTIEL_RESIDUEL_MW,
        KD.MATURITE_MARCHE_PV,
        KD.PIB_PAR_HABITANT_EUR,
        
        -- Score d'attractivité composite (0-100)
        ROUND(
            (LEAST(100, KD.POTENTIEL_RESIDUEL_MW / 100) * 0.3) +  -- 30% potentiel résiduel
            (GREATEST(0, 100 - KD.TAUX_SATURATION_POTENTIEL_PERCENT) * 0.3) +  -- 30% non-saturation
            (LEAST(100, KD.EVOLUTION_W_PAR_HAB_PERCENT) * 0.2) +  -- 20% dynamique
            (LEAST(100, KD.PIB_PAR_HABITANT_EUR / 300) * 0.2)     -- 20% pouvoir d'achat
        , 1) AS SCORE_ATTRACTIVITE
        
    FROM VW_KPI_PUISSANCE_PAR_HABITANT KD
    CROSS JOIN DERNIERE_ANNEE DA
    WHERE KD.ANNEE = DA.ANNEE_REF
)
SELECT 
    NOM_REGION,
    WATTS_PAR_HABITANT,
    RANG_NATIONAL_W_PAR_HAB AS RANG_NATIONAL,
    ROUND(TAUX_SATURATION_POTENTIEL_PERCENT, 1) AS SATURATION_PERCENT,
    ROUND(EVOLUTION_W_PAR_HAB_PERCENT, 1) AS CROISSANCE_ANNUELLE_PERCENT,
    ROUND(POTENTIEL_RESIDUEL_MW / 1000, 2) AS POTENTIEL_RESIDUEL_GW,
    SCORE_ATTRACTIVITE,
    
    -- Catégorisation stratégique
    CASE 
        WHEN SCORE_ATTRACTIVITE >= 70 THEN '🟢 PRIORITE_MAXIMALE'
        WHEN SCORE_ATTRACTIVITE >= 50 THEN '🟡 OPPORTUNITE'
        WHEN SCORE_ATTRACTIVITE >= 30 THEN '🟠 POTENTIEL_MOYEN'
        ELSE '🔴 FAIBLE_PRIORITE'
    END AS RECOMMANDATION_STRATEGIQUE,
    
    -- Insights spécifiques
    CASE 
        WHEN TAUX_SATURATION_POTENTIEL_PERCENT < 30 AND EVOLUTION_W_PAR_HAB_PERCENT > 15 
        THEN 'Marché en forte croissance avec potentiel résiduel important'
        WHEN TAUX_SATURATION_POTENTIEL_PERCENT > 70 
        THEN 'Marché mature - Focus maintenance et renouvellement'
        WHEN WATTS_PAR_HABITANT < 150 AND POTENTIEL_RESIDUEL_MW > 500
        THEN 'Marché sous-développé - Opportunité majeure'
        ELSE 'Développement standard'
    END AS INSIGHT_PRINCIPAL,
    
    MATURITE_MARCHE_PV,
    CURRENT_TIMESTAMP() AS DATE_ANALYSE
    
FROM ANALYSE_REGIONALE
ORDER BY SCORE_ATTRACTIVITE DESC;

-- =====================================================================================
-- ÉTAPE 8: GESTION D'ERREURS ET MONITORING  
-- =====================================================================================

USE SCHEMA DW_PHOTOVOLTAIQUE.MONITORING;

-- Table de logs d'exécution
CREATE OR REPLACE TABLE LOG_EXECUTION (
    ID_LOG                          INTEGER AUTOINCREMENT PRIMARY KEY,
    PROCEDURE_NAME                  VARCHAR(100),
    FICHIER_SOURCE                  VARCHAR(500),
    NB_LIGNES_TRAITEES              INTEGER,
    NB_LIGNES_REJETEES              INTEGER,
    TIMESTAMP_DEBUT                 TIMESTAMP_NTZ,
    TIMESTAMP_FIN                   TIMESTAMP_NTZ,
    DUREE_SECONDES                  INTEGER,
    STATUT                          VARCHAR(20),  -- SUCCESS/ERROR/WARNING
    MESSAGE_ERREUR                  VARCHAR(2000),
    UTILISATEUR                     VARCHAR(100) DEFAULT CURRENT_USER(),
    ENVIRONNEMENT                   VARCHAR(20) DEFAULT 'PROD'
)
COMMENT = 'Journal d\'exécution des procédures ETL';

-- Table d'alertes qualité données
CREATE OR REPLACE TABLE ALERTES_QUALITE (
    ID_ALERTE                       INTEGER AUTOINCREMENT PRIMARY KEY,
    TYPE_ALERTE                     VARCHAR(50),  -- MISSING_DATA/OUTLIER/INCONSISTENCY
    DESCRIPTION_ALERTE              VARCHAR(500),
    TABLE_CONCERNEE                 VARCHAR(100),
    COLONNE_CONCERNEE               VARCHAR(100),
    VALEUR_DETECTEE                 VARCHAR(100),
    SEUIL_ALERTE                    VARCHAR(100),
    CRITICITE                       VARCHAR(20),  -- LOW/MEDIUM/HIGH/CRITICAL
    DATE_DETECTION                  TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    DATE_RESOLUTION                 TIMESTAMP_NTZ,
    STATUT_ALERTE                   VARCHAR(20) DEFAULT 'OPEN',  -- OPEN/ACKNOWLEDGED/RESOLVED
    RESPONSABLE                     VARCHAR(100),
    ACTION_CORRECTIVE               VARCHAR(500)
)
COMMENT = 'Alertes automatiques sur la qualité des données';

-- Procédure de contrôle qualité post-chargement
CREATE OR REPLACE PROCEDURE SP_CONTROLE_QUALITE()
RETURNS STRING
LANGUAGE SQL
COMMENT = 'Contrôles qualité automatiques après chargement'
AS
$
DECLARE
    V_NB_ALERTES INTEGER DEFAULT 0;
BEGIN
    -- Contrôle 1: Détection des valeurs aberrantes production solaire
    INSERT INTO ALERTES_QUALITE (TYPE_ALERTE, DESCRIPTION_ALERTE, TABLE_CONCERNEE, COLONNE_CONCERNEE, 
                                 VALEUR_DETECTEE, SEUIL_ALERTE, CRITICITE)
    SELECT 
        'OUTLIER',
        'Production solaire anormalement élevée pour la région',
        'FACT_PRODUCTION_ENERGIE',
        'PRODUCTION_GWH',
        PRODUCTION_GWH::VARCHAR,
        '10000 GWh',
        'HIGH'
    FROM DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE F
    JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_GEOGRAPHIE G ON F.GEOGRAPHIE_KEY = G.GEOGRAPHIE_KEY
    WHERE F.FILIERE_KEY = 'SOLAIRE_PV'
    AND F.PRODUCTION_GWH > 10000  -- Seuil arbitraire très élevé
    AND F.DATE_MAJ >= CURRENT_DATE - 1;  -- Données récentes seulement
    
    GET DIAGNOSTICS V_NB_ALERTES = ROW_COUNT;
    
    -- Contrôle 2: Détection des régressions importantes
    INSERT INTO ALERTES_QUALITE (TYPE_ALERTE, DESCRIPTION_ALERTE, TABLE_CONCERNEE, COLONNE_CONCERNEE,
                                 VALEUR_DETECTEE, SEUIL_ALERTE, CRITICITE)
    SELECT 
        'INCONSISTENCY',
        'Forte régression de production vs année précédente: ' || NOM_REGION,
        'FACT_PRODUCTION_ENERGIE', 
        'CROISSANCE_RELATIVE_PERCENT',
        CROISSANCE_RELATIVE_PERCENT::VARCHAR || '%',
        '-50%',
        'MEDIUM'
    FROM DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE F
    JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_GEOGRAPHIE G ON F.GEOGRAPHIE_KEY = G.GEOGRAPHIE_KEY
    JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER C ON F.DATE_KEY = C.DATE_KEY
    WHERE F.FILIERE_KEY = 'SOLAIRE_PV'
    AND F.CROISSANCE_RELATIVE_PERCENT < -50  -- Régression > 50%
    AND C.ANNEE = YEAR(CURRENT_DATE);  -- Année en cours
    
    V_NB_ALERTES := V_NB_ALERTES + ROW_COUNT;
    
    -- Contrôle 3: Détection données manquantes récentes
    INSERT INTO ALERTES_QUALITE (TYPE_ALERTE, DESCRIPTION_ALERTE, TABLE_CONCERNEE, COLONNE_CONCERNEE,
                                 VALEUR_DETECTEE, SEUIL_ALERTE, CRITICITE)
    SELECT 
        'MISSING_DATA',
        'Données de production manquantes pour région: ' || NOM_REGION || ' année: ' || ANNEE_ATTENDUE,
        'FACT_PRODUCTION_ENERGIE',
        'PRODUCTION_GWH',
        'NULL',
        '0',
        'HIGH'
    FROM (
        SELECT G.NOM_REGION, C.ANNEE AS ANNEE_ATTENDUE
        FROM DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_GEOGRAPHIE G
        CROSS JOIN (SELECT DISTINCT ANNEE FROM DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER 
                   WHERE ANNEE >= YEAR(CURRENT_DATE) - 2) C  -- 3 dernières années
        WHERE G.NIVEAU_GEOGRAPHIQUE = 'REGIONAL'
        
        EXCEPT
        
        SELECT G.NOM_REGION, CAL.ANNEE 
        FROM DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE F
        JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_GEOGRAPHIE G ON F.GEOGRAPHIE_KEY = G.GEOGRAPHIE_KEY
        JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER CAL ON F.DATE_KEY = CAL.DATE_KEY
        WHERE F.FILIERE_KEY = 'SOLAIRE_PV'
        AND G.NIVEAU_GEOGRAPHIQUE = 'REGIONAL'
    ) DONNEES_MANQUANTES;
    
    V_NB_ALERTES := V_NB_ALERTES + ROW_COUNT;
    
    RETURN 'Contrôles qualité terminés - ' || V_NB_ALERTES || ' alertes générées';
    
END;
$;

-- Vue de monitoring des alertes actives
CREATE OR REPLACE VIEW VW_MONITORING_ALERTES_ACTIVES
COMMENT = 'Tableau de bord des alertes qualité ouvertes'
AS
SELECT 
    TYPE_ALERTE,
    CRITICITE,
    COUNT(*) AS NB_ALERTES,
    MIN(DATE_DETECTION) AS PLUS_ANCIENNE,
    MAX(DATE_DETECTION) AS PLUS_RECENTE,
    
    CASE CRITICITE
        WHEN 'CRITICAL' THEN '🔴 CRITIQUE'
        WHEN 'HIGH' THEN '🟠 HAUTE'  
        WHEN 'MEDIUM' THEN '🟡 MOYENNE'
        ELSE '🟢 FAIBLE'
    END AS NIVEAU_CRITICITE,
    
    ROUND(AVG(DATEDIFF('HOUR', DATE_DETECTION, CURRENT_TIMESTAMP)), 1) AS DUREE_MOYENNE_HEURES
    
FROM DW_PHOTOVOLTAIQUE.MONITORING.ALERTES_QUALITE
WHERE STATUT_ALERTE = 'OPEN'
GROUP BY TYPE_ALERTE, CRITICITE
ORDER BY 
    CASE CRITICITE 
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH' THEN 2  
        WHEN 'MEDIUM' THEN 3
        ELSE 4 
    END,
    NB_ALERTES DESC;

-- =====================================================================================
-- ÉTAPE 9: EXEMPLE D'UTILISATION ET SCRIPTS DE TEST
-- =====================================================================================

-- Script d'exemple pour charger les données du fichier CSV analysé
/*
-- 1. Chargement des données brutes en staging
COPY INTO DW_PHOTOVOLTAIQUE.STAGING.STG_PRODUCTION_REGIONALE_RAW (
    ANNEE, CODE_INSEE_REGION, REGION, PRODUCTION_NUCLEAIRE_GWH, PRODUCTION_THERMIQUE_GWH,
    PRODUCTION_HYDRAULIQUE_GWH, PRODUCTION_EOLIENNE_GWH, PRODUCTION_SOLAIRE_GWH, PRODUCTION_BIOENERGIES_GWH,
    FICHIER_SOURCE, NUMERO_LIGNE_FICHIER
)
FROM (
    SELECT 
        $1::INTEGER, $2::INTEGER, $3::VARCHAR, $4::DECIMAL(12,3), $5::DECIMAL(12,3),
        $6::DECIMAL(12,3), $7::DECIMAL(12,3), $8::DECIMAL(12,3), $9::DECIMAL(12,3),
        'prodregionannuellefiliere.csv', METADATA$FILE_ROW_NUMBER
    FROM @STAGE_FICHIERS_CSV/prodregionannuellefiliere.csv
)
FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ';' SKIP_HEADER = 1 NULL_IF = ('', 'NULL'));

-- 2. Exécution du traitement ETL complet
CALL DW_PHOTOVOLTAIQUE.STAGING.SP_CHARGER_PRODUCTION_REGIONALE('prodregionannuellefiliere.csv', FALSE);

-- 3. Contrôle qualité post-chargement
CALL DW_PHOTOVOLTAIQUE.MONITORING.SP_CONTROLE_QUALITE();
*/

-- =====================================================================================
-- ÉTAPE 10: REQUÊTES DE VALIDATION ET TESTS
-- =====================================================================================

-- Test 1: Validation cohérence données chargées vs source
/*
SELECT 
    'Validation totaux par année' AS TEST,
    CAL.ANNEE,
    COUNT(*) AS NB_REGIONS,
    ROUND(SUM(F.PRODUCTION_GWH), 1) AS TOTAL_PRODUCTION_SOLAIRE_GWH,
    
    -- Comparaison avec totaux attendus du fichier source (à adapter selon les données)
    CASE 
        WHEN CAL.ANNEE = 2024 AND ROUND(SUM(F.PRODUCTION_GWH), 0) = 24804 THEN '✅ COHERENT'
        WHEN CAL.ANNEE = 2023 AND ROUND(SUM(F.PRODUCTION_GWH), 0) BETWEEN 18000 AND 20000 THEN '✅ COHERENT'  
        ELSE '❌ A_VERIFIER'
    END AS STATUT_VALIDATION
    
FROM DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE F
JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER CAL ON F.DATE_KEY = CAL.DATE_KEY
WHERE F.FILIERE_KEY = 'SOLAIRE_PV'
GROUP BY CAL.ANNEE
ORDER BY CAL.ANNEE DESC;
*/

-- Test 2: Validation des KPIs calculés
/*
SELECT 
    'Test KPIs prioritaires' AS TEST,
    ANNEE,
    PUISSANCE_INSTALLEE_GW,
    CROISSANCE_RELATIVE_PERCENT,
    CASE 
        WHEN PUISSANCE_INSTALLEE_GW > 0 AND PUISSANCE_INSTALLEE_GW < 100 THEN '✅ PLAUSIBLE'
        ELSE '❌ ABERRANT' 
    END AS VALIDATION_PUISSANCE,
    CASE 
        WHEN CROISSANCE_RELATIVE_PERCENT BETWEEN -20 AND 200 THEN '✅ PLAUSIBLE'
        ELSE '❌ ABERRANT'
    END AS VALIDATION_CROISSANCE
    
FROM DW_PHOTOVOLTAIQUE.MARTS.VW_KPI_CROISSANCE_PUISSANCE
ORDER BY ANNEE DESC
LIMIT 5;
*/

-- Test 3: Validation intégrité référentielle
/*
SELECT 
    'Contrôle intégrité' AS TEST,
    COUNT(DISTINCT F.GEOGRAPHIE_KEY) AS NB_REGIONS_FAITS,
    COUNT(DISTINCT G.GEOGRAPHIE_KEY) AS NB_REGIONS_DIM,
    COUNT(DISTINCT F.DATE_KEY) AS NB_DATES_FAITS,
    COUNT(DISTINCT C.DATE_KEY) AS NB_DATES_DIM,
    
    CASE 
        WHEN COUNT(DISTINCT F.GEOGRAPHIE_KEY) = COUNT(DISTINCT G.GEOGRAPHIE_KEY) 
        THEN '✅ GEOGRAPHIE_OK' 
        ELSE '❌ GEOGRAPHIE_KO'
    END AS STATUT_GEO,
    
    CASE 
        WHEN COUNT(DISTINCT F.DATE_KEY) <= COUNT(DISTINCT C.DATE_KEY)
        THEN '✅ DATES_OK'
        ELSE '❌ DATES_KO' 
    END AS STATUT_DATES
    
FROM DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE F
LEFT JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_GEOGRAPHIE G ON F.GEOGRAPHIE_KEY = G.GEOGRAPHIE_KEY
LEFT JOIN DW_PHOTOVOLTAIQUE.DIMENSIONS.DIM_CALENDRIER C ON F.DATE_KEY = C.DATE_KEY
WHERE F.FILIERE_KEY = 'SOLAIRE_PV';
*/

-- =====================================================================================
-- ÉTAPE 11: DOCUMENTATION ET EXEMPLES RÉSULTATS ATTENDUS
-- =====================================================================================

-- Exemple de résultat attendu KPI 1 (Puissance installée)
/*
ANNÉE    RÉGION                     PUISSANCE_GW  CROISSANCE_%  WATTS/HAB  RANG
2024     Nouvelle-Aquitaine         6.84          +18.2         1,135      1
2024     Occitanie                  5.95          +15.8         967        2  
2024     Provence-Alpes-Côte d'Azur 3.88          +11.4         761        3
2024     Auvergne-Rhône-Alpes      3.41          +22.1         424        4
2024     Grand Est                 1.98          +12.3         356        5
*/

-- Exemple de résultat attendu KPI synthèse nationale  
/*
ANNÉE  PUISSANCE_GW  PRODUCTION_TWH  FC_MOYEN_%  COUVERTURE_CONSO_%  STATUT_PPE
2024   28.2          24.8            14.2        5.5                 TRAJECTOIRE_CORRECTE
2023   24.1          18.5            13.8        4.1                 EFFORT_SUPPLEMENTAIRE_REQUIS  
2022   20.8          15.2            13.5        3.4                 EFFORT_SUPPLEMENTAIRE_REQUIS
*/

-- =====================================================================================
-- ÉTAPE 12: PROCÉDURES DE MAINTENANCE ET OPTIMISATION
-- =====================================================================================

-- Procédure de maintenance des partitions
CREATE OR REPLACE PROCEDURE SP_MAINTENANCE_PARTITIONS()
RETURNS STRING  
LANGUAGE SQL
AS
$
BEGIN
    -- Suppression des anciennes partitions (> 10 ans)
    ALTER TABLE DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE 
    DROP PARTITION IF EXISTS (ANNEE_PARTITION < YEAR(CURRENT_DATE) - 10);
    
    -- Création des nouvelles partitions (année courante + 2)
    ALTER TABLE DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE 
    ADD PARTITION IF NOT EXISTS (ANNEE_PARTITION = YEAR(CURRENT_DATE) + 1);
    
    ALTER TABLE DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE 
    ADD PARTITION IF NOT EXISTS (ANNEE_PARTITION = YEAR(CURRENT_DATE) + 2);
    
    -- Reclustering des données récentes
    ALTER TABLE DW_PHOTOVOLTAIQUE.FACTS.FACT_PRODUCTION_ENERGIE RECLUSTER;
    
    RETURN 'Maintenance partitions terminée - ' || CURRENT_TIMESTAMP();
END;
$;

-- Procédure de purge des logs anciens  
CREATE OR REPLACE PROCEDURE SP_PURGE_LOGS_ANCIENS()
RETURNS STRING
LANGUAGE SQL  
AS
$
DECLARE
    V_NB_SUPPRIMES INTEGER;
BEGIN
    -- Suppression des logs > 6 mois
    DELETE FROM DW_PHOTOVOLTAIQUE.MONITORING.LOG_EXECUTION
    WHERE TIMESTAMP_DEBUT < DATEADD('MONTH', -6, CURRENT_TIMESTAMP());
    
    GET DIAGNOSTICS V_NB_SUPPRIMES = ROW_COUNT;
    
    -- Suppression des rejets > 3 mois
    DELETE FROM DW_PHOTOVOLTAIQUE.STAGING.STG_REJETS_DONNEES  
    WHERE DATE_REJET < DATEADD('MONTH', -3, CURRENT_TIMESTAMP());
    
    -- Suppression des alertes résolues > 1 an
    DELETE FROM DW_PHOTOVOLTAIQUE.MONITORING.ALERTES_QUALITE
    WHERE STATUT_ALERTE = 'RESOLVED' 
    AND DATE_RESOLUTION < DATEADD('YEAR', -1, CURRENT_TIMESTAMP());
    
    RETURN 'Purge terminée - ' || V_NB_SUPPRIMES || ' logs supprimés';
END;
$;

-- =====================================================================================
-- ÉTAPE 13: TASK SCHEDULER POUR AUTOMATISATION
-- =====================================================================================

-- Tâche de chargement quotidien (si nouvelles données)
CREATE OR REPLACE TASK TASK_ETL_QUOTIDIEN
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 0 6 * * * Europe/Paris'  -- 6h du matin
    COMMENT = 'Chargement automatique données production énergétique'
AS
    CALL DW_PHOTOVOLTAIQUE.STAGING.SP_CHARGER_PRODUCTION_REGIONALE(NULL, FALSE);

-- Tâche de contrôle qualité après chargement
CREATE OR REPLACE TASK TASK_CONTROLE_QUALITE
    WAREHOUSE = COMPUTE_WH
    AFTER TASK_ETL_QUOTIDIEN
    COMMENT = 'Contrôle qualité post-ETL'
AS  
    CALL DW_PHOTOVOLTAIQUE.MONITORING.SP_CONTROLE_QUALITE();

-- Tâche de maintenance hebdomadaire
CREATE OR REPLACE TASK TASK_MAINTENANCE_HEBDO
    WAREHOUSE = COMPUTE_WH  
    SCHEDULE = 'USING CRON 0 2 * * 0 Europe/Paris'  -- Dimanche 2h
    COMMENT = 'Maintenance hebdomadaire base de données'
AS
    CALL DW_PHOTOVOLTAIQUE.STAGING.SP_MAINTENANCE_PARTITIONS();

-- Activation des tâches  
ALTER TASK TASK_ETL_QUOTIDIEN RESUME;
ALTER TASK TASK_CONTROLE_QUALITE RESUME; 
ALTER TASK TASK_MAINTENANCE_HEBDO RESUME;

-- =====================================================================================
-- ÉTAPE 14: GRANTS ET SÉCURITÉ
-- =====================================================================================

-- Création des rôles métier
CREATE ROLE IF NOT EXISTS ROLE_OBSERVATOIRE_LECTEUR;
CREATE ROLE IF NOT EXISTS ROLE_OBSERVATOIRE_ANALYSTE; 
CREATE ROLE IF NOT EXISTS ROLE_OBSERVATOIRE_ADMIN;

-- Permissions lecture seule (Dirigeants, Managers)
GRANT USAGE ON DATABASE DW_PHOTOVOLTAIQUE TO ROLE ROLE_OBSERVATOIRE_LECTEUR;
GRANT USAGE ON SCHEMA DW_PHOTOVOLTAIQUE.MARTS TO ROLE ROLE_OBSERVATOIRE_LECTEUR;
GRANT SELECT ON ALL VIEWS IN SCHEMA DW_PHOTOVOLTAIQUE.MARTS TO ROLE ROLE_OBSERVATOIRE_LECTEUR;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA DW_PHOTOVOLTAIQUE.MARTS TO ROLE ROLE_OBSERVATOIRE_LECTEUR;

-- Permissions analyste (Équipes techniques)  
GRANT ROLE ROLE_OBSERVATOIRE_LECTEUR TO ROLE ROLE_OBSERVATOIRE_ANALYSTE;
GRANT USAGE ON SCHEMA DW_PHOTOVOLTAIQUE.FACTS TO ROLE ROLE_OBSERVATOIRE_ANALYSTE;  
GRANT USAGE ON SCHEMA DW_PHOTOVOLTAIQUE.DIMENSIONS TO ROLE ROLE_OBSERVATOIRE_ANALYSTE;
GRANT SELECT ON ALL TABLES IN SCHEMA DW_PHOTOVOLTAIQUE.FACTS TO ROLE ROLE_OBSERVATOIRE_ANALYSTE;
GRANT SELECT ON ALL TABLES IN SCHEMA DW_PHOTOVOLTAIQUE.DIMENSIONS TO ROLE ROLE_OBSERVATOIRE_ANALYSTE;

-- Permissions admin (Data Engineers)
GRANT ROLE ROLE_OBSERVATOIRE_ANALYSTE TO ROLE ROLE_OBSERVATOIRE_ADMIN;
GRANT ALL ON DATABASE DW_PHOTOVOLTAIQUE TO ROLE ROLE_OBSERVATOIRE_ADMIN;
GRANT ALL ON ALL SCHEMAS IN DATABASE DW_PHOTOVOLTAIQUE TO ROLE ROLE_OBSERVATOIRE_ADMIN;

-- =====================================================================================
-- FIN DU PIPELINE SNOWFLAKE COMPLET
-- =====================================================================================

-- Commande de validation finale
SELECT 
    '🎉 PIPELINE PHOTOVOLTAIQUE DÉPLOYÉ AVEC SUCCÈS' AS MESSAGE,
    CURRENT_TIMESTAMP() AS DATE_DEPLOIEMENT,
    CURRENT_USER() AS DEPLOYE_PAR,
    '✅ Prêt pour chargement données CSV analysées' AS STATUT;

-- Pour charger les données du fichier CSV analysé :
-- 1. Créer un stage: CREATE STAGE STAGE_FICHIERS_CSV;  
-- 2. Uploader le fichier: PUT file://prodregionannuellefiliere.csv @STAGE_FICHIERS_CSV;
-- 3. Exécuter: COPY INTO + SP_CHARGER_PRODUCTION_REGIONALE() comme dans les exemples ci-dessus
-- 4. Consulter les KPIs: SELECT * FROM VW_SYNTHESE_NATIONALE_ANNUELLE;