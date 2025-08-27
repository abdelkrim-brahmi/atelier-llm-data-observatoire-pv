# Activité 3.1 : Stratégie de Test Complète

## 🎯 Contexte d'Usage
Créer un plan de recette exhaustif pour valider une solution Data avant livraison client avec un niveau de qualité professionnel.

## ⏱️ Temps Alloué
20 minutes

## 👤 Votre Rôle
QA Engineer expert en projets Data avec expérience client secteur énergétique

## 📋 Livrable Attendu
Plan de recette structuré et jeux de tests opérationnels

## 🤖 Prompt à Copier-Coller

```
Agis comme un QA Engineer expert en projets Data avec une expérience client dans l'énergie.

CONTEXTE : Mon observatoire photovoltaïque est techniquement prêt. Avant la livraison client, je dois créer un plan de recette exhaustif qui garantit la qualité et la fiabilité de la solution.

MISSION : Crée un plan de tests complet couvrant tous les aspects critiques

1. TESTS UNITAIRES DATA
   - Validation des transformations colonne par colonne
   - Contrôles de cohérence (totaux, évolutions, ratios)
   - Tests des règles métier implémentées
   - Jeux de données de test avec résultats attendus

2. TESTS D'INTÉGRATION
   - Bout-en-bout depuis l'ingestion jusqu'aux KPIs
   - Tests de performance sur volumétries réelles
   - Résilience aux formats de données dégradés
   - Gestion des cas d'erreur et reprises

3. TESTS FONCTIONNELS MÉTIER
   - Scénarios utilisateur réalistes
   - Validation des KPIs avec benchmarks externes
   - Cohérence temporelle des évolutions
   - Tests des seuils d'alerte et notifications

4. TESTS NON-FONCTIONNELS
   - Performance : temps de réponse des requêtes KPIs
   - Volumétrie : tenue en charge sur 5 ans de données
   - Sécurité : droits d'accès et confidentialité
   - Disponibilité : tests de reprise après panne

5. RECETTE UTILISATEUR
   - Protocole de validation avec le client
   - Critères d'acceptation mesurables
   - Processus de validation des anomalies
   - Formation et transfert de compétences

Pour chaque type de test, fournis des exemples concrets applicables à notre observatoire photovoltaïque.
```

## ✅ Critères de Validation

- [ ] Plan structuré couvrant tous les aspects techniques et métier
- [ ] Jeux de données de test fournis avec résultats attendus
- [ ] Critères d'acceptation quantifiés (ex: KPI à +/-2% près)
- [ ] Protocole de validation client formalisé

## 🔧 Prompts de Spécialisation

### Focus sur l'Automatisation
```
Enrichis le plan de tests avec une stratégie d'automatisation :
- Scripts de tests automatisés pour les contrôles récurrents
- Intégration dans un pipeline CI/CD avec Snowflake
- Tests de régression automatiques à chaque déploiement
- Alertes automatiques en cas de dégradation de qualité
- Dashboard de suivi de la qualité en temps réel
```

### Adaptation par Environnement
```
Adapte le plan pour les environnements DEV/RECETTE/PROD :
- Stratégie de synchronisation des données de test
- Tests spécifiques à chaque environnement
- Procédures de promotion entre environnements
- Tests de disaster recovery et continuité de service
- Validation des configurations par environnement
```

### Tests de Performance Avancés
```
Approfondis les tests de performance :
- Tests de charge avec utilisateurs simultanés
- Tests de volumétrie sur historique 10 ans
- Benchmarking des temps de réponse par KPI
- Tests de montée en charge progressive
- Optimisation des requêtes lentes identifiées
```

## ⏱️ Optimisation du Timing (20 minutes)

### Répartition Recommandée
1. **3 minutes** - Lancer le prompt principal
2. **12 minutes** - Laisser ChatGPT générer le plan complet
3. **3 minutes** - Lire et identifier les sections prioritaires
4. **2 minutes** - Demander précisions sur les aspects critiques

### Focus si Temps Limité
**P0 (Essentiel) :**
- Tests unitaires des KPIs critiques
- Tests d'intégration bout-en-bout
- Critères d'acceptation client

**P1 (Important) :**
- Tests de performance
- Jeux de données de validation

**P2 (Nice-to-have) :**
- Tests de sécurité avancés
- Procédures de formation

## 📋 Template de Cas de Test

```markdown
## Test Case #TC001 - Calcul KPI Production Régionale

**Objectif :** Valider le calcul précis de la production PV par région
**Prérequis :** Données 2023-2024 chargées et transformées
**Priorité :** P0 (Critique)
**Durée estimée :** 15 minutes

### Données d'Entrée
```sql
-- Dataset de test (PACA 2023)
INSERT INTO STG_PRODUCTION_TEST VALUES
('2023-01-01', 'Provence-Alpes-Côte d''Azur', 'Solaire', 125.5),
('2023-01-02', 'Provence-Alpes-Côte d''Azur', 'Solaire', 134.2),
('2023-01-03', 'Provence-Alpes-Côte d''Azur', 'Solaire', 128.7);
```

### Résultat Attendu
- **Production totale PACA 2023 :** 3,456.7 GWh ±1%
- **Rang national :** 2ème région productrice
- **Évolution vs 2022 :** +12.3% ±0.5%

### Procédure de Test
1. Exécuter la requête : `SELECT * FROM VW_PRODUCTION_REGIONALE WHERE region='PACA' AND annee=2023`
2. Comparer avec benchmark RTE officiel
3. Vérifier les calculs d'évolution temporelle
4. Contrôler les agrégations mensuelles

### Critères de Succès
- [ ] Valeur dans fourchette ±1% vs benchmark
- [ ] Cohérence avec source officielle RTE
- [ ] Temps d'exécution < 5 secondes
- [ ] Pas d'erreur SQL lors de l'exécution

### Actions si Échec
1. Analyser l'écart avec source de référence
2. Vérifier la logique de transformation
3. Contrôler les données source (complétude, doublons)
4. Ajuster les règles de calcul si nécessaire
```

## 🎯 Scénarios de Test Métier Prioritaires

### Scénario 1 : Dirigeant Analyse Opportunités
```
Contexte : Un dirigeant veut identifier les 3 régions les plus prometteuses
Persona : CEO d'un installateur PV national
Actions :
1. Consulter le dashboard principal
2. Filtrer sur croissance > 15% annuelle
3. Analyser la densité de marché par région
4. Exporter le top 3 pour comité stratégique

Critères de succès :
- Chargement dashboard < 10 secondes
- Filtres fonctionnels et intuitifs  
- Données cohérentes avec analyses internes
- Export PDF généré sans erreur
```

### Scénario 2 : Investisseur Évalue Portefeuille
```
Contexte : Un fonds évalue la performance de ses actifs PV
Persona : Directeur d'investissement spécialisé EnR
Actions :
1. Comparer ROI par type d'installation
2. Analyser l'évolution des tarifs d'achat
3. Identifier les risques géographiques
4. Calculer les projections sur 3 ans

Critères de succès :
- KPIs financiers précis (±2% vs calculs internes)
- Historique complet depuis 2012
- Projections basées sur tendances réelles
- Alertes sur évolutions réglementaires
```

### Scénario 3 : Collectivité Pilote Transition
```
Contexte : Une région suit l'atteinte de ses objectifs SRADDET
Persona : Directeur transition énergétique territorial
Actions :
1. Mesurer l'avancement vs objectifs 2030
2. Identifier les freins au développement
3. Benchmarker vs autres régions
4. Préparer rapport pour élus

Critères de succès :
- Suivi temps réel des objectifs réglementaires
- Analyse des écarts et causes racines
- Comparaisons inter-territoriales pertinentes
- Rapport automatisé pour gouvernance
```

## 🛡️ Matrice de Couverture des Tests

| Fonctionnalité | Tests Unitaires | Tests Intégration | Tests Métier | Tests Performance | Tests Sécurité |
|----------------|-----------------|-------------------|--------------|-------------------|----------------|
| **Ingestion données** | ✅ | ✅ | ❌ | ✅ | ✅ |
| **Transformations** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Calculs KPIs** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Dashboard** | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Alertes** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Exports** | ❌ | ✅ | ✅ | ✅ | ✅ |

**Objectif :** 100% de couverture sur fonctionnalités P0

## 🔧 Outils et Automatisation

### Scripts de Test Automatisés
```sql
-- Procédure de validation automatique
CREATE OR REPLACE PROCEDURE SP_TESTS_QUALITE_AUTO()
RETURNS TABLE (test_name STRING, status STRING, details STRING)
LANGUAGE SQL
AS
$$
BEGIN
    -- Test 1: Volumétrie des données
    INSERT INTO results 
    SELECT 'Volumétrie données' as test_name,
           CASE WHEN COUNT(*) > 10000 THEN 'PASS' ELSE 'FAIL' END as status,
           'Records: ' || COUNT(*) as details
    FROM FAIT_PRODUCTION;
    
    -- Test 2: Cohérence KPIs
    INSERT INTO results
    SELECT 'Cohérence KPI Production' as test_name,
           CASE WHEN ABS(total_calc - total_ref)/total_ref < 0.02 
                THEN 'PASS' ELSE 'FAIL' END as status,
           'Écart: ' || ROUND((total_calc - total_ref)/total_ref * 100, 2) || '%' as details
    FROM (
        SELECT SUM(production_gwh) as total_calc FROM VW_PRODUCTION_NATIONALE
    ) calc,
    (
        SELECT 25.6 as total_ref  -- Référence RTE 2024
    ) ref;
    
    RETURN TABLE(results);
END;
$$;
```

### Dashboard de Monitoring Qualité
```sql
-- Vue de suivi qualité temps réel
CREATE VIEW VW_MONITORING_QUALITE AS
SELECT 
    'Fraîcheur données' as indicateur,
    DATEDIFF('hour', MAX(date_maj), CURRENT_TIMESTAMP()) as valeur,
    '< 24h' as seuil,
    CASE WHEN DATEDIFF('hour', MAX(date_maj), CURRENT_TIMESTAMP()) < 24 
         THEN '🟢' ELSE '🔴' END as statut
FROM FACT_PRODUCTION

UNION ALL

SELECT 
    'Complétude régions' as indicateur,
    COUNT(DISTINCT region) as valeur, 
    '13 régions' as seuil,
    CASE WHEN COUNT(DISTINCT region) = 13 THEN '🟢' ELSE '🔴' END as statut
FROM DIM_GEOGRAPHIE;
```

## 📊 Critères d'Acceptation Client

### Critères Quantitatifs
- **Précision KPIs :** ±2% vs benchmarks officiels (RTE, ODRE)
- **Performance :** 95% des requêtes < 5 secondes
- **Disponibilité :** 99.9% uptime sur heures ouvrées
- **Complétude :** 100% des régions métropolitaines couvertes

### Critères Qualitatifs  
- **Ergonomie :** Formation utilisateur < 2h pour autonomie
- **Fiabilité :** 0 erreur critique sur période de test 1 mois
- **Évolutivité :** Capacité d'intégrer 2 nouvelles sources/an
- **Support :** Documentation complète et support technique

## ⚠️ Risques et Mitigation

### Risques Techniques
| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|---------|------------|
| **Performance dégradée** | Moyenne | Fort | Tests charge + optimisation SQL |
| **Données incohérentes** | Faible | Critique | Validation croisée sources multiples |
| **Panne environnement** | Faible | Fort | Backup automatique + procédures reprise |

### Risques Métier
| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|---------|------------|
| **Rejet utilisateur** | Moyenne | Fort | Sessions UAT + formation personnalisée |
| **Évolution réglementaire** | Forte | Moyen | Monitoring veille + architecture flexible |
| **Concurrence** | Moyenne | Moyen | Différenciation fonctionnelle + roadmap |

Cette structure garantit une validation complète et professionnelle de la solution en 20 minutes de préparation intensive !
