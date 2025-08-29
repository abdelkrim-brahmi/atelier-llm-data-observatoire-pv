# Activité 2.1 : Analyse Sources + Modèle Cible

## 🎯 Contexte d'Usage
Analyser rapidement des fichiers de données réelles et concevoir le modèle dimensionnel optimal en approche intégrée.

## ⏱️ Temps Alloué
20 minutes

## 👤 Votre Rôle
Data Engineer senior spécialisé dans l'intégration de données énergétiques

## 📊 Ressource Fournie
Un [fichier CVS](https://github.com/abdelkrim-brahmi/atelier-llm-data-observatoire-pv/blob/main/data/raw/prod-region-annuelle-filiere.csv) de données de production électrique en France (dont photovoltaïques)

## 🎯 Livrable Attendu
Modèle dimensionnel + mapping source-cible complet

## 🤖 Prompt à Copier-Coller (avec Upload de Fichiers)

```
Agis comme un Data Engineer senior spécialisé dans l'intégration de données énergétiques.

CONTEXTE : J'ai une source de données de production électrique, dont photovoltaïques, françaises [UPLOAD VOTRE FICHIER CSV]. Je dois créer un data warehouse Snowflake optimisé pour alimenter notre observatoire stratégique.

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
Avant d'upload, vérifiez que votre fichier :
- Est au format CSV avec encodage UTF-8
- A des headers explicites en première ligne
- Fait moins de 100 MB (limite upload Copilot)
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

Afin de nous aligner sur les étapes suivantes :
- **Exemple d'analyse de source** :  [datawarehouse_conception_pv](../../sample%20results/analyse_sources_resultat.md)


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
