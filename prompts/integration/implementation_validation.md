# Activité 2.3 : Implémentation et Validation

## 🎯 Contexte d'Usage
Déployer et tester le pipeline de données dans un environnement Snowflake réel avec validation des résultats métier.

## ⏱️ Temps Alloué
40 minutes

## 🎯 Mission
Déployer et tester dans Snowflake réel

## 🛠️ Livrable Attendu
Modèle de données opérationnel avec KPIs validés sur vraies données

## 📋 Checklist d'Implémentation

### 1. **Connexion Snowflake**
- [ ] Connexion à votre environnement [Snowflake Teamwork](https://a3857344721571-teamworkcorp_partner.snowflakecomputing.com/console/login)
- [ ] Création du schéma de travail
- [ ] Vérification des droits (CREATE, INSERT, SELECT)

### 2. **Déploiement Progressif**
- [ ] Exécution DDL tables staging → OK/KO
- [ ] Exécution DDL dimensions → OK/KO  
- [ ] Exécution DDL faits → OK/KO
- [ ] Exécution vues métier → OK/KO
    **Exemples de DDL**(si besoin) :  [datawarehouse_conception_pv](../../sample%20results/analyse_sources_resultat.md)

### 3. **Chargement des Données**
- [ ] Upload des fichiers sources dans Snowflake
- [ ] Exécution transformations staging → dimensions
- [ ] Chargement table de faits
- [ ] Contrôle volumétrie (nombre de lignes attendu vs réel)

### 4. **Validation Métier**
- [ ] Test des 3 vues KPIs prioritaires
- [ ] Vérification cohérence des résultats
- [ ] Contrôle des agrégations temporelles

## 🤖 Prompt de Debug (si erreurs)

```
J'ai cette erreur Snowflake : [COLLER L'ERREUR COMPLÈTE]

Sur ce code : [COLLER LE CODE QUI PLANTE]

Peux-tu :
1. Identifier la cause précise du problème
2. Me donner le code corrigé
3. Expliquer pourquoi ça plantait et comment éviter ce type d'erreur
4. Suggérer des bonnes pratiques Snowflake pour ce cas
```

## 🎯 Objectif de Fin d'Activité

À la fin des 40 minutes, vous devez avoir dans Snowflake :
- Un modèle de données fonctionnel avec vraies données
- Au moins 3 requêtes KPIs qui retournent des résultats cohérents
- Une compréhension des points de vigilance technique

## ⏱️ Planning Détaillé (40 minutes)

### Phase 1 : Setup et Connexion (5 minutes)
```sql
-- 1. Connexion à votre environnement Snowflake
USE WAREHOUSE COMPUTE_WH;
USE DATABASE OBSERVATOIRE_PV;

-- 2. Création de l'environnement de travail
CREATE SCHEMA IF NOT EXISTS GROUPE_[VOTRE_NUMERO];
USE SCHEMA GROUPE_[VOTRE_NUMERO];

-- 3. Test des droits
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_DATABASE(), CURRENT_SCHEMA();
```

### Phase 2 : Déploiement Infrastructure (15 minutes)
```sql
-- Étape 1: Tables Staging (5 min)
-- Exécuter le DDL généré par Copilot en 2.2
-- Vérifier : SHOW TABLES LIKE 'STG_%';

-- Étape 2: Tables Dimensions (5 min)  
-- Exécuter le DDL des dimensions
-- Vérifier : SHOW TABLES LIKE 'DIM_%';

-- Étape 3: Tables de Faits (5 min)
-- Exécuter le DDL des faits
-- Vérifier : SHOW TABLES LIKE 'FAIT_%';
```

### Phase 3 : Chargement de Données (15 minutes)
```sql
-- Étape 1: Upload des fichiers CSV (5 min)
-- Utiliser l'interface Snowflake ou commandes COPY INTO

-- Étape 2: Chargement Dimensions (5 min)
-- Exécuter les scripts de transformation staging → dimensions

-- Étape 3: Chargement Faits (5 min) 
-- Exécuter les scripts de chargement des faits
```

### Phase 4 : Validation et Tests (5 minutes)
```sql
-- Test 1: Volumétrie
SELECT 'Installations' as table_name, COUNT(*) as nb_records FROM FAIT_INSTALLATIONS
UNION ALL
SELECT 'Production' as table_name, COUNT(*) as nb_records FROM FAIT_PRODUCTION
UNION ALL  
SELECT 'Dimensions Géo' as table_name, COUNT(*) as nb_records FROM DIM_GEOGRAPHIE;

-- Test 2: KPIs essentiels
SELECT * FROM VW_PUISSANCE_REGIONALE LIMIT 10;
SELECT * FROM VW_PRODUCTION_ANNUELLE LIMIT 10;
SELECT * FROM VW_TOP_REGIONS LIMIT 5;
```

## 🛡️ Guide de Résolution d'Erreurs

### Erreurs Courantes et Solutions

#### 1. Erreur de Connexion/Droits
```
SQL compilation error: Object '[TABLE]' does not exist
```

**Diagnostic :**
```sql
-- Vérifier l'environnement actuel
SELECT CURRENT_DATABASE(), CURRENT_SCHEMA(), CURRENT_WAREHOUSE();

-- Vérifier les droits
SHOW GRANTS TO ROLE [VOTRE_ROLE];
```

**Solution :** Adapter les noms de schéma/database ou demander les droits manquants

#### 2. Erreur de Type de Données
```
Numeric value '[VALUE]' is not recognized
```

**Diagnostic :**
```sql
-- Identifier les valeurs problématiques
SELECT column_name, COUNT(*) 
FROM table_name 
WHERE TRY_CAST(column_name AS NUMBER) IS NULL
GROUP BY column_name;
```

**Solution :** Nettoyer les données ou ajuster les types

#### 3. Erreur de Clé Étrangère
```
Foreign key constraint violated
```

**Diagnostic :**
```sql
-- Vérifier l'intégrité référentielle
SELECT f.region_key, COUNT(*) as nb_in_fait
FROM FAIT_PRODUCTION f
LEFT JOIN DIM_GEOGRAPHIE d ON f.region_key = d.region_key
WHERE d.region_key IS NULL
GROUP BY f.region_key;
```

**Solution :** Charger les dimensions avant les faits

## 🔧 Prompts Spécialisés par Type d'Erreur

### Pour Erreurs de Performance
```
Mon requête prend plus de 30 secondes à s'exécuter :
[COLLER LA REQUÊTE LENTE]

Mes tables ont ces volumes :
- Table A : X millions de lignes
- Table B : Y millions de lignes

Peux-tu :
1. Identifier les goulots d'étranglement
2. Proposer des optimisations (index, clustering, requête)
3. Suggérer une stratégie de clustering keys
4. Recommander la taille de warehouse appropriée
```

### Pour Erreurs de Qualité de Données
```
J'ai des résultats incohérents dans mes KPIs :
- KPI attendu : [VALEUR ATTENDUE]
- KPI calculé : [VALEUR OBTENUE]  
- Différence : X%

Voici ma requête : [COLLER LA REQUÊTE]
Et mes données source : [DÉCRIRE LES SOURCES]

Aide-moi à :
1. Identifier la source de l'écart
2. Valider la logique de calcul
3. Proposer des contrôles qualité
4. Ajouter des assertions dans le code
```

### Pour Erreurs d'Intégration
```
Mes transformations staging → dimensions échouent :
[COLLER L'ERREUR]

Structure de mes données sources :
[COLLER QUELQUES LIGNES EXEMPLE]

Structure cible :
[COLLER LE DDL DE LA DIMENSION]

Peux-tu :
1. Corriger la logique de transformation
2. Gérer les cas de données manquantes/aberrantes
3. Ajouter des contrôles de validation
4. Optimiser pour les performances
```

## ✅ Critères de Validation Finale

### Tests Fonctionnels Obligatoires
```sql
-- TEST 1: Cohérence des volumes
SELECT 
    'Cohérence installations' as test,
    CASE 
        WHEN ABS(COUNT_STAGING - COUNT_DIM) / COUNT_STAGING < 0.1 
        THEN 'PASS' 
        ELSE 'FAIL' 
    END as statut
FROM (
    SELECT COUNT(*) as COUNT_STAGING FROM STG_INSTALLATIONS
) s,
(
    SELECT COUNT(*) as COUNT_DIM FROM DIM_INSTALLATIONS  
) d;

-- TEST 2: Intégrité référentielle
SELECT 
    'Intégrité FK région' as test,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END as statut
FROM FAIT_PRODUCTION f
LEFT JOIN DIM_GEOGRAPHIE g ON f.region_key = g.region_key
WHERE g.region_key IS NULL;

-- TEST 3: Cohérence métier des KPIs
SELECT 
    'KPI Production France' as test,
    total_production_gwh,
    CASE 
        WHEN total_production_gwh BETWEEN 10 AND 50 -- Fourchette réaliste
        THEN 'PASS' 
        ELSE 'FAIL' 
    END as statut
FROM (
    SELECT SUM(production_gwh) as total_production_gwh
    FROM VW_PRODUCTION_ANNUELLE 
    WHERE annee = 2024
);
```

### Dashboard de Validation
```sql
-- Vue de contrôle pour validation rapide
CREATE VIEW VW_VALIDATION_DASHBOARD AS
SELECT 
    'Tables créées' as categorie,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES 
     WHERE TABLE_SCHEMA = CURRENT_SCHEMA()) as valeur,
    '8+' as attendu,
    
UNION ALL

SELECT 
    'Données chargées' as categorie,
    (SELECT COUNT(*) FROM FAIT_PRODUCTION) as valeur,
    '1000+' as attendu,
    
UNION ALL

SELECT 
    'KPIs fonctionnels' as categorie, 
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.VIEWS
     WHERE VIEW_SCHEMA = CURRENT_SCHEMA() 
     AND VIEW_NAME LIKE 'VW_%') as valeur,
    '3+' as attendu;
```

## 🎯 Objectifs par Profil

### Débutant (Objectif Minimum)
- [ ] Tables créées sans erreur
- [ ] Données chargées (même partiellement)
- [ ] 1 KPI fonctionnel avec résultat cohérent

### Intermédiaire (Objectif Standard)
- [ ] Pipeline complet opérationnel
- [ ] 3 KPIs validés avec benchmarks
- [ ] Gestion d'erreur basique implémentée

### Avancé (Objectif Excellence)
- [ ] Optimisations performance appliquées
- [ ] Tests automatisés créés
- [ ] Monitoring et alertes configurés

## 🚀 Extensions si Temps Disponible

### Optimisations Performance
```sql
-- Ajout de clustering keys
ALTER TABLE FAIT_PRODUCTION CLUSTER BY (date_key, region_key);

-- Analyse des statistiques
SELECT SYSTEM$CLUSTERING_INFORMATION('FAIT_PRODUCTION', '(date_key, region_key)');
```

### Tests Automatisés
```sql
-- Procédure de validation automatique
CREATE OR REPLACE PROCEDURE SP_VALIDATION_QUALITE()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    nb_erreurs NUMBER DEFAULT 0;
    message STRING DEFAULT '';
BEGIN
    -- Tests de validation ici
    RETURN CASE WHEN nb_erreurs = 0 THEN 'SUCCÈS' ELSE message END;
END;
$$;
```

Cette structure assure un déploiement méthodique et une validation complète en 40 minutes !
