# Activité 2.2 : Génération Pipeline Complet

## 🎯 Contexte d'Usage
Générer l'intégralité du code SQL Snowflake pour implémenter le pipeline de données de l'observatoire photovoltaïque.

## ⏱️ Temps Alloué
30 minutes

## 👤 Votre Rôle
Data Engineer senior implémentant l'architecture conçue en activité 2.1

## 🛠️ Livrable Attendu
Scripts SQL Snowflake complets et documentés, prêts pour déploiement

## 🤖 Prompt à Copier-Coller

```
Maintenant génère le pipeline Snowflake complet basé sur ton analyse.

MISSION : Code SQL complet pour implémenter l'intégralité du flux de données

1. COUCHE STAGING (RAW DATA)
   - Tables de réception des données brutes
   - Gestion des formats et encodages
   - Colonnes techniques (date_insertion, source_fichier, etc.)
   - Contraintes et validations de base

2. COUCHE DIMENSIONNELLE
   - DDL des tables de dimension avec SCD Type 1/2 si nécessaire
   - Scripts de chargement depuis le staging
   - Gestion des référentiels (codes région, types technologie)
   - Index et contraintes d'intégrité

3. COUCHE FACTS
   - Table de faits avec métriques de base et calculées
   - Clés étrangères vers les dimensions
   - Partitioning et clustering pour les performances
   - Triggers de mise à jour si pertinents

4. VUES MÉTIER
   - Vues pour chacun des 5 KPIs prioritaires
   - Agrégations multi-niveaux (national/régional/mensuel/annuel)
   - Documentation intégrée en commentaires SQL
   - Exemples de résultats attendus

5. GESTION D'ERREURS
   - Logs d'exécution et monitoring
   - Gestion des rejets et reprises sur incident
   - Alertes sur anomalies de données

Génère tout le code d'un coup, bien commenté et prêt à déployer sur la base du chargement du fichier CSV analysé précédemment.
```

## ✅ Critères de Validation

- [ ] DDL complet (staging + dimensions + faits + vues)
- [ ] Scripts de transformation documentés
- [ ] Gestion d'erreurs et logging intégrés
- [ ] Optimisations Snowflake (clustering, partitions)

## 💡 Astuce Technique

Si le code généré est trop long, demandez à Copilot de le découper par couches successives, mais gardez la logique d'ensemble cohérente.

## 🔧 Prompts de Découpage si Nécessaire

### Si le Code est Trop Volumineux
```
Le code est très complet mais trop long. Découpe-le en 3 parties distinctes :

PARTIE 1 - INFRASTRUCTURE & STAGING
- Création des schémas et tables staging
- Procédures de chargement des données brutes
- Gestion des erreurs d'ingestion

PARTIE 2 - MODÈLE DIMENSIONNEL  
- DDL complet des dimensions et faits
- Scripts de transformation et chargement
- Contraintes et optimisations

PARTIE 3 - COUCHE MÉTIER & MONITORING
- Vues KPIs avec documentation
- Procédures de monitoring et alertes
- Scripts de maintenance
```

### Pour Optimiser les Performances
```
Enrichis le code avec des optimisations Snowflake avancées :
- Clustering keys optimaux selon les patterns de requête
- Vues matérialisées pour les agrégations coûteuses
- Configuration des warehouses par type de charge
- Stratégies de partitioning temporel
- Estimation des coûts par couche de données
```

### Pour la Production
```
Adapte le code pour un environnement de production :
- Gestion des environnements (DEV/TEST/PROD)
- Procédures de déploiement automatisé
- Stratégies de sauvegarde et restauration
- Monitoring et alerting opérationnel
- Procédures de rollback en cas de problème
```

## ⏱️ Optimisation du Timing (30 minutes)

### Répartition Recommandée
1. **3 minutes** - Lancer le prompt principal
2. **20 minutes** - Laisser Copilot générer l'ensemble du pipeline
3. **5 minutes** - Lire et identifier les sections prioritaires
4. **2 minutes** - Demander précisions sur points critiques si nécessaire

### Priorités si Manque de Temps
**P0 (Essential) :**
- DDL des tables principales (staging, dimensions, faits)
- Scripts de transformation de base

**P1 (Important) :**
- Vues KPIs prioritaires
- Gestion d'erreurs basique

**P2 (Nice-to-have) :**
- Optimisations avancées
- Monitoring complet

## 📋 Résultat Attendu

Afin de nous aligner sur les étapes suivantes :
- **Exemple de pipleline complet** :  [pipeline_snowflake_complet](../../sample%20results/pipeline_snowflake_complet.sql)


## 📋 Structure de Code Attendue

```sql
-- ====================================
-- OBSERVATOIRE PHOTOVOLTAIQUE FRANCE
-- Pipeline Snowflake Complet
-- ====================================

-- PARTIE 1: INFRASTRUCTURE
CREATE DATABASE IF NOT EXISTS OBSERVATOIRE_PV;
CREATE SCHEMA IF NOT EXISTS OBSERVATOIRE_PV.STAGING;
CREATE SCHEMA IF NOT EXISTS OBSERVATOIRE_PV.DWH;
CREATE SCHEMA IF NOT EXISTS OBSERVATOIRE_PV.MARTS;

-- PARTIE 2: STAGING TABLES
CREATE TABLE OBSERVATOIRE_PV.STAGING.STG_INSTALLATIONS (
    -- Colonnes métier
    code_insee VARCHAR(5),
    puiss_max_rac NUMBER(8,2),
    -- Colonnes techniques
    date_insertion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source_fichier VARCHAR(100),
    hash_record VARCHAR(64)
);

-- PARTIE 3: DIMENSIONS
CREATE TABLE OBSERVATOIRE_PV.DWH.DIM_TEMPS (
    date_key NUMBER(8,0) PRIMARY KEY,
    [...]
);

-- [etc.]
```

## 🛡️ Checklist de Qualité du Code

### Standards Snowflake
- [ ] **Nommage cohérent** : MAJUSCULES avec underscores
- [ ] **Types appropriés** : NUMBER pour MW, DATE pour temporel
- [ ] **Commentaires** : Chaque table/vue documentée
- [ ] **Contraintes** : Primary keys, foreign keys définies

### Optimisations Performance
- [ ] **Clustering keys** : Sur DATE + REGION pour les faits
- [ ] **Vues matérialisées** : Pour agrégations fréquentes
- [ ] **Partitioning** : Temporel pour l'historique
- [ ] **Compression** : Configuration optimale par type de données

### Gestion d'Erreurs
- [ ] **Try-catch blocks** : Pour les transformations critiques
- [ ] **Logs détaillés** : Traçabilité des opérations
- [ ] **Validation métier** : Contrôles de cohérence
- [ ] **Alertes** : Sur seuils d'anomalies

## 🔧 Exemples de Code Attendu

### Table de Staging avec Colonnes Techniques
```sql
CREATE TABLE OBSERVATOIRE_PV.STAGING.STG_PRODUCTION_REGIONALE (
    -- Colonnes métier
    annee NUMBER(4,0),
    region VARCHAR(50),
    filiere VARCHAR(20),
    production_gwh NUMBER(10,2),
    
    -- Colonnes techniques pour traçabilité
    date_insertion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source_fichier VARCHAR(100),
    hash_record VARCHAR(64) DEFAULT SHA2(CONCAT(annee, region, filiere)),
    statut_qualite VARCHAR(10) DEFAULT 'PENDING',
    
    -- Contraintes
    CONSTRAINT pk_stg_prod PRIMARY KEY (annee, region, filiere),
    CONSTRAINT chk_production_positive CHECK (production_gwh >= 0)
);
```

### Vue KPI avec Documentation
```sql
-- =====================================================
-- VUE KPI: Puissance Installée par Région et Année
-- Usage: Dashboard principal + analyses territoriales
-- Fréquence: Mise à jour mensuelle
-- =====================================================
CREATE VIEW OBSERVATOIRE_PV.MARTS.VW_PUISSANCE_REGIONALE AS
SELECT 
    dg.nom_region,
    dt.annee,
    SUM(fp.puissance_mw) as total_puissance_mw,
    COUNT(DISTINCT fp.installation_key) as nb_installations,
    ROUND(AVG(fp.puissance_mw), 2) as puissance_moyenne_mw,
    -- Calcul d'évolution YoY
    LAG(SUM(fp.puissance_mw)) OVER (
        PARTITION BY dg.nom_region 
        ORDER BY dt.annee
    ) as puissance_annee_precedente,
    -- Pourcentage d'évolution
    ROUND(
        (SUM(fp.puissance_mw) / LAG(SUM(fp.puissance_mw)) OVER (
            PARTITION BY dg.nom_region ORDER BY dt.annee
        ) - 1) * 100, 
        1
    ) as evolution_pct
FROM OBSERVATOIRE_PV.DWH.FAIT_PRODUCTION_PV fp
JOIN OBSERVATOIRE_PV.DWH.DIM_GEOGRAPHIE dg ON fp.region_key = dg.region_key
JOIN OBSERVATOIRE_PV.DWH.DIM_TEMPS dt ON fp.date_key = dt.date_key
GROUP BY dg.nom_region, dt.annee
ORDER BY dt.annee DESC, total_puissance_mw DESC;

-- Exemple de résultat attendu:
-- nom_region          | annee | total_puissance_mw | evolution_pct
-- Provence-Alpes-CA   | 2024  | 3450.5            | 12.3
-- Occitanie           | 2024  | 3201.8            | 15.7
```

## 🚨 Points de Vigilance

### Erreurs Courantes à Éviter
- **Noms de colonnes ambigus** : `date` au lieu de `date_installation`
- **Types inadéquats** : VARCHAR pour des montants numériques
- **Oubli des contraintes** : Pas de primary keys définies
- **Pas d'optimisation** : Tables sans clustering keys

### Spécificités Snowflake
- **Quotes** : Éviter les guillemets sauf cas particulier
- **Sequences** : Utiliser IDENTITY pour les clés auto-incrémentées
- **Clustering** : Maximum 4 colonnes recommandées
- **Warehouses** : Dimensionner selon la charge attendue

## 🎯 Extensions Avancées

### Si le Temps le Permet
```
Ajoute des fonctionnalités avancées :
- Procédures stockées pour automatiser les chargements
- Triggers pour maintenir la cohérence référentielle
- Vues paramétrées pour différents profils utilisateur
- Scripts de test unitaire pour valider les transformations
- Procédures de purge automatique des données anciennes
```

### Intégration Continue
```
Génère aussi les scripts DevOps :
- Scripts de déploiement par environnement
- Tests automatisés de régression
- Configuration des jobs d'orchestration
- Monitoring des performances et coûts
- Alertes opérationnelles sur Slack/Teams
```

Cette structure garantit un pipeline Snowflake complet et production-ready en 30 minutes d'activité intensive !
