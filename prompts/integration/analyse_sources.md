# Activité 2.1 : Analyse Sources + Modèle Cible

## 🎯 Contexte d'Usage
Analyser rapidement des fichiers de données réelles et concevoir le modèle dimensionnel optimal en approche intégrée.

## ⏱️ Temps Alloué
20 minutes

## 👤 Votre Rôle
Data Engineer senior spécialisé dans l'intégration de données énergétiques

## 📊 Ressources Fournies
Vos 3 fichiers de données photovoltaïques français

## 🎯 Livrable Attendu
Modèle dimensionnel + mapping source-cible complet

## 🤖 Prompt à Copier-Coller (avec Upload de Fichiers)

```
Agis comme un Data Engineer senior spécialisé dans l'intégration de données énergétiques.

CONTEXTE : J'ai ces 3 sources de données photovoltaïques françaises [UPLOAD VOS 3 FICHIERS]. Je dois créer un data warehouse Snowflake optimisé pour alimenter notre observatoire stratégique.

MISSION INTÉGRÉE : En analysant ces sources, conçois en une seule démarche :

1. ANALYSE DES SOURCES
   - Structure et schéma de chaque fichier
   - Qualité des données (complétude, cohérence, doublons)
   - Volumétrie estimée et fréquence de mise à jour
   - Problèmes potentiels identifiés

2. MODÈLE DIMENSIONNEL OPTIMAL
   - Schéma en étoile adapté aux analyses photovoltaïques
   - Tables de dimension (temps, géographie, technologie, etc.)
   - Table(s) de faits avec métriques clés
   - Granularité optimale pour les cas d'usage business

3. MAPPING SOURCE-VERS-CIBLE
   - Correspondance champs sources → modèle cible
   - Règles de transformation nécessaires
   - Gestion des valeurs manquantes et aberrantes
   - Clés de jointure et relations

4. RÈGLES DE CALCUL KPI
   - Formules pour les 5 indicateurs prioritaires (P0)
   - Agrégations temporelles et géographiques
   - Gestion de l'historique et des évolutions

Sois précis sur les noms de colonnes et types de données Snowflake.
```

## ✅ Critères de Validation

- [ ] Modèle dimensionnel cohérent (1-2 faits + 3-4 dimensions)
- [ ] Mapping complet source → cible documenté
- [ ] Règles de calcul des KPIs P0 définies
- [ ] Types Snowflake appropriés (VARCHAR, NUMBER, DATE, etc.)

## 💡 Conseils d'Optimisation

### Préparation des Fichiers
```
Avant d'upload, vérifiez que vos 3 fichiers :
- Sont au format CSV avec encodage UTF-8
- Ont des headers explicites en première ligne
- Font moins de 25 MB chacun (limite ChatGPT)
- Représentent bien les 3 typologies : installations, production, capacités
```

### Maximiser l'Efficacité du Prompt
```
Pour optimiser l'analyse, ajoutez après le prompt principal :
"Base ton analyse sur un échantillon représentatif si les fichiers sont volumineux.
Privilégie la cohérence du modèle dimensionnel plutôt que l'exhaustivité des détails.
Propose des noms de tables/colonnes respectant les conventions Snowflake."
```

## 🔧 Prompts de Spécialisation

### Focus sur la Qualité des Données
```
Approfondis l'analyse qualité en ajoutant :
- Profiling statistique des colonnes numériques clés
- Détection d'outliers avec seuils recommandés pour le photovoltaïque
- Analyse des patterns temporels (saisonnalité, tendances)
- Règles de validation métier spécifiques au secteur énergétique
- Stratégies de nettoyage et d'enrichissement automatisé
```

### Optimisation Performance Snowflake
```
Enrichis le modèle avec les optimisations Snowflake :
- Stratégie de clustering pour les tables de faits (par date + région)
- Partitioning optimal pour l'historique (annuel/mensuel)
- Recommandations de vues matérialisées pour les agrégations courantes
- Estimation des coûts de stockage et compute sur 3 ans
- Configuration warehouse selon les patterns d'usage
```

### Extensibilité du Modèle
```
Ajoute une section évolutivité :
- Comment intégrer de nouvelles sources (éolien, hydraulique) ?
- Stratégie de migration sans interruption (blue/green deployment)
- Gestion du versioning du modèle de données
- Plan de montée en charge (passage de Go à To de données)
- Architecture multi-environnements (dev/test/prod)
```

## 📋 Structure de Réponse Attendue

```markdown
# ANALYSE INTÉGRÉE - SOURCES PHOTOVOLTAÏQUES

## 📊 DIAGNOSTIC DES SOURCES

### Fichier 1 : registre_installations_pv_2025.csv
- **Volume :** 47,832 lignes, 12 colonnes
- **Qualité :** 96% complétude, 3 doublons détectés
- **Structure :**
  ```
  code_insee          VARCHAR(5)    - Code commune INSEE
  puiss_max_rac      NUMBER(8,2)   - Puissance raccordée MW
  date_rac           DATE          - Date de raccordement
  [...]
  ```

### Fichier 2 : production_regionale_2012-2024.csv
[Analyse similaire]

### Fichier 3 : parc_eolien_solaire_regional.csv
[Analyse similaire]

## 🏗️ MODÈLE DIMENSIONNEL PROPOSÉ

```sql
-- TABLE DE FAITS PRINCIPALE
CREATE TABLE FAIT_PRODUCTION_PV (
    date_key          NUMBER(8,0),
    region_key        NUMBER(4,0),
    installation_key  NUMBER(10,0),
    production_mwh    NUMBER(10,2),
    puissance_mw      NUMBER(8,2),
    facteur_charge    NUMBER(5,4)
);

-- DIMENSIONS
CREATE TABLE DIM_TEMPS (
    date_key      NUMBER(8,0) PRIMARY KEY,
    date_complete DATE,
    annee         NUMBER(4,0),
    mois          NUMBER(2,0),
    trimestre     NUMBER(1,0)
);

CREATE TABLE DIM_GEOGRAPHIE (
    region_key    NUMBER(4,0) PRIMARY KEY,
    code_region   VARCHAR(2),
    nom_region    VARCHAR(50),
    code_dept     VARCHAR(3),
    nom_dept      VARCHAR(50)
);
```

## 🔄 MAPPING & TRANSFORMATIONS

### Source 1 → DIM_GEOGRAPHIE
```sql
INSERT INTO DIM_GEOGRAPHIE 
SELECT 
    ROW_NUMBER() OVER (ORDER BY nom_region) as region_key,
    SUBSTR(code_insee, 1, 2) as code_region,
    nom_region,
    SUBSTR(code_insee, 1, 3) as code_dept,
    nom_commune
FROM registre_installations_pv_2025
WHERE [conditions de nettoyage]
```

## 📈 CALCULS KPIs PRIORITAIRES

### KPI 1 : Puissance Installée Cumulée
```sql
CREATE VIEW VW_PUISSANCE_CUMULEE AS
SELECT 
    dg.nom_region,
    dt.annee,
    SUM(fp.puissance_mw) as total_puissance_mw
FROM FAIT_PRODUCTION_PV fp
JOIN DIM_GEOGRAPHIE dg ON fp.region_key = dg.region_key
JOIN DIM_TEMPS dt ON fp.date_key = dt.date_key
GROUP BY dg.nom_region, dt.annee
```
```

## ⚡ Optimisation du Timing (20 minutes)

### Répartition Recommandée
1. **2 minutes** - Upload des 3 fichiers et lancement du prompt
2. **12 minutes** - Laisser ChatGPT analyser et générer le modèle complet
3. **4 minutes** - Lire et valider la cohérence du modèle proposé
4. **2 minutes** - Ajustements mineurs avec prompt de raffinement si nécessaire

### Signaux d'une Bonne Analyse
- ✅ **Modèle en étoile classique** avec 1 fait central + 4-5 dimensions
- ✅ **Noms explicites** respectant conventions Snowflake (majuscules, underscores)
- ✅ **Types adaptés** aux données énergétiques (NUMBER pour MW, DATE pour temporel)
- ✅ **Mapping détaillé** avec exemples de code SQL
- ✅ **Règles métier** spécifiques au photovoltaïque

## 🛠️ Techniques Avancées

### Gestion des Données Temporelles
```sql
-- Gestion des séries temporelles avec gaps
CREATE TABLE DIM_TEMPS_COMPLET AS
SELECT 
    TO_NUMBER(TO_CHAR(date_seq, 'YYYYMMDD')) as date_key,
    date_seq as date_complete,
    EXTRACT(YEAR FROM date_seq) as annee,
    EXTRACT(MONTH FROM date_seq) as mois
FROM TABLE(GENERATOR(ROWCOUNT => 3650)) -- 10 ans de données
QUALIFY ROW_NUMBER() OVER (ORDER BY SEQ4()) = 1
```

### Dimensions à Évolution Lente (SCD)
```sql
-- Gestion SCD Type 2 pour évolutions réglementaires
CREATE TABLE DIM_INSTALLATION (
    installation_key  NUMBER IDENTITY PRIMARY KEY,
    code_installation VARCHAR(50),
    regime_tarifaire  VARCHAR(50),
    date_debut        DATE,
    date_fin          DATE,
    est_actuel        BOOLEAN
);
```

## 🔍 Points de Vigilance

### Qualité des Données
- **Cohérence inter-sources** : Vérifier que les totaux régionaux matchent
- **Valeurs aberrantes** : Puissances > 1000 MW (centrales vs toitures)  
- **Complétude temporelle** : Séries continues sans trous
- **Référentiels** : Codes région cohérents entre sources

### Performance Snowflake
- **Clustering keys** : DATE + REGION pour les patterns de requête courants
- **Taille des warehouses** : XS pour dev, M pour prod selon volumétrie
- **Coûts** : Attention aux full-scan sur historique complet

## 🎯 Validation Finale

### Checklist Technique
- [ ] Le modèle supporte-t-il tous les KPIs identifiés en Phase 1 ?
- [ ] Les jointures sont-elles optimisées (clés numériques) ?
- [ ] La granularité permet-elle les analyses temporelles fines ?
- [ ] Le modèle est-il extensible pour de nouvelles sources ?

### Test de Cohérence
```sql
-- Vérification des volumes après transformation
SELECT 
    'Source' as niveau,
    COUNT(*) as nb_records
FROM staging_registre_installations
UNION ALL
SELECT 
    'Cible' as niveau,
    COUNT(DISTINCT installation_key) as nb_records  
FROM FAIT_PRODUCTION_PV
-- Le nombre doit être cohérent (±5% acceptable pour nettoyage)
```

Cette structure garantit un modèle dimensionnel robuste et optimisé en 20 minutes d'analyse intensive !
