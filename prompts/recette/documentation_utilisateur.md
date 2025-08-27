# Activité 3.2 : Documentation Utilisateur

## 🎯 Contexte d'Usage
Créer un package documentaire complet et professionnel pour permettre au client d'utiliser, maintenir et faire évoluer la solution en autonomie.

## ⏱️ Temps Alloué
20 minutes

## 👤 Votre Rôle
Technical Writer spécialisé dans la documentation de solutions Data pour entreprises

## 📚 Livrable Attendu
Package documentaire complet pour le client

## 🤖 Prompt à Copier-Coller

```
Agis comme un Technical Writer spécialisé dans la documentation de solutions Data pour des clients entreprises.

CONTEXTE : Je livre l'observatoire photovoltaïque à mon client. Il faut une documentation complète pour qu'il puisse utiliser, maintenir et faire évoluer la solution de manière autonome.

MISSION : Crée le package documentaire complet

1. GUIDE UTILISATEUR DASHBOARD
   - Prise en main rapide (quick start)
   - Description de chaque KPI avec interprétation business
   - Navigation et fonctionnalités interactives
   - Cas d'usage types avec captures d'écran (décris-les en texte)
   - FAQ utilisateur avec réponses

2. DICTIONNAIRE DE DONNÉES
   - Catalogue complet des indicateurs avec définitions
   - Sources de données et fraîcheur
   - Règles de calcul en langage métier
   - Limites et précautions d'interprétation

3. GUIDE D'ADMINISTRATION TECHNIQUE
   - Architecture de la solution et composants
   - Procédures de mise à jour des données
   - Monitoring et surveillance (que surveiller ?)
   - Gestion des incidents courants
   - Contacts support et escalade

4. GUIDE DE MAINTENANCE ET ÉVOLUTION
   - Comment ajouter de nouveaux KPIs
   - Intégration de nouvelles sources de données
   - Modifications des calculs existants
   - Procédures de sauvegarde et restauration

5. ANNEXES TECHNIQUES
   - Modèle de données détaillé
   - Dictionnaire des tables Snowflake
   - Scripts de requêtes utiles pour les analyses ad-hoc
   - Changelog et versions

Rédige dans un style professionnel mais accessible, avec une structure claire et des exemples pratiques.
```

## ✅ Critères de Validation

- [ ] Guide utilisateur avec navigation pas-à-pas
- [ ] Documentation technique complète et précise
- [ ] FAQ anticipant les questions client courantes
- [ ] Procédures de maintenance documentées

## 🔧 Prompts de Spécialisation

### Adaptation par Profil Utilisateur
```
Personnalise la documentation pour 3 profils utilisateur distincts :

PROFIL DIRIGEANT :
- Focus sur l'interprétation business des KPIs
- Raccourcis pour accéder aux informations clés
- Glossaire des termes techniques
- Cas d'usage pour prises de décision rapides

PROFIL ANALYSTE :
- Détails techniques sur les calculs
- Procédures d'analyse approfondie
- Export de données et analyses ad-hoc
- Validation et contrôles qualité

PROFIL ADMINISTRATEUR IT :
- Gestion technique de la plateforme
- Procédures de dépannage avancées
- Configuration et optimisation
- Sécurité et gestion des droits
```

### Focus sur l'Autonomie Client
```
Enrichis la documentation pour maximiser l'autonomie client :
- Procédures de self-service pour les demandes courantes
- Scripts automatisés pour les tâches répétitives
- Checklists de validation pour les modifications
- Procédures de formation interne pour nouveaux utilisateurs
- Guide de montée en compétence progressive (débutant → expert)
```

### Documentation Évolutive
```
Ajoute une section "Documentation Vivante" :
- Template de mise à jour pour chaque évolution
- Processus de validation des modifications documentaires
- Versioning de la documentation avec changelog
- Feedback loop utilisateur pour amélioration continue
- Intégration avec les outils collaboratifs client (Confluence, SharePoint)
```

## ⏱️ Optimisation du Timing (20 minutes)

### Répartition Recommandée
1. **3 minutes** - Lancer le prompt principal complet
2. **12 minutes** - Laisser ChatGPT générer le package documentaire
3. **3 minutes** - Lire et évaluer la complétude
4. **2 minutes** - Raffiner les sections critiques pour le client

### Priorités si Temps Limité
**P0 (Essential) :**
- Guide utilisateur dashboard (navigation + KPIs)
- FAQ des questions courantes
- Procédures de base administration

**P1 (Important) :**
- Dictionnaire de données complet
- Guide de maintenance
- Contacts et escalade

**P2 (Nice-to-have) :**
- Annexes techniques détaillées
- Scripts avancés d'analyse
- Procédures d'évolution

## 📋 Structure de Documentation Attendue

```markdown
# OBSERVATOIRE PHOTOVOLTAÏQUE - DOCUMENTATION UTILISATEUR
Version 1.0 | Date : [DATE] | Auteur : [ÉQUIPE]

## 📖 TABLE DES MATIÈRES
1. [Guide Utilisateur Dashboard](#guide-utilisateur)
2. [Dictionnaire de Données](#dictionnaire)
3. [Guide Administration](#administration)
4. [Maintenance et Évolution](#maintenance)
5. [Annexes Techniques](#annexes)

---

## 1. GUIDE UTILISATEUR DASHBOARD

### 🚀 Prise en Main Rapide (5 minutes)
**Première connexion :**
1. Accédez à l'URL : https://observatoire-pv.[votre-domaine].com
2. Connectez-vous avec vos identifiants Active Directory
3. Cliquez sur "Dashboard Principal" dans le menu gauche
4. Vous arrivez sur la vue d'ensemble nationale

**Navigation essentielles :**
- **Onglet "Vue d'ensemble"** : KPIs nationaux et tendances
- **Onglet "Territorial"** : Analyses par région/département  
- **Onglet "Évolution"** : Séries temporelles et projections
- **Filtre temporel** : Sélection période (en haut à droite)

### 📊 Description des KPIs Principaux

#### KPI #1 : Puissance Installée Cumulée
- **Définition :** Total des installations PV raccordées au réseau
- **Unité :** Mégawatts (MW)
- **Interprétation :** 
  - Mesure la taille globale du marché français
  - Évolution positive = croissance du secteur
  - À comparer avec objectifs PPE (Programmation Pluriannuelle Énergie)
- **Mise à jour :** Mensuelle (source RTE)
- **Valeur de référence 2024 :** ~15,200 MW

#### KPI #2 : Taux de Croissance Annuel
- **Définition :** Évolution année sur année de la puissance installée
- **Unité :** Pourcentage (%)
- **Interprétation :**
  - > 15% : Marché en forte croissance
  - 5-15% : Croissance modérée  
  - < 5% : Ralentissement, vigilance requise
- **Seuils d'alerte :** Croissance < 5% (notification automatique)

[Continuer pour tous les KPIs...]

### 🔍 Cas d'Usage Types

#### Cas #1 : "Identifier les régions prometteuses"
**Contexte :** Dirigeant planifie expansion commerciale
**Étapes :**
1. Onglet "Territorial" → vue carte France
2. Filtrer "Taux croissance" → sélectionner ">15%"
3. Observer les régions en vert foncé (forte croissance)
4. Cliquer sur région → drill-down départemental
5. Exporter top 3 → bouton "Export PDF"

**Capture écran :** [DESCRIPTION]
Vue carte de France avec dégradé de couleurs :
- Vert foncé : Nouvelle-Aquitaine, Occitanie (>20% croissance)  
- Vert moyen : Grand Est, Auvergne-Rhône-Alpes (10-20%)
- Jaune : Île-de-France, Hauts-de-France (5-10%)
- Rouge : Corse (<5% ou décroissance)

#### Cas #2 : "Analyser la performance vs concurrence"
**Contexte :** Investisseur évalue son portefeuille
**Étapes :**
1. Onglet "Évolution" → graphique ROI moyen
2. Sélectionner sa région d'activité dans filtre
3. Comparer courbe "Mon portefeuille" vs "Marché"
4. Identifier périodes de sous-performance
5. Corréler avec événements réglementaires (annotations graphique)

### ❓ FAQ Utilisateur

**Q : Pourquoi mes KPIs sont différents de mes calculs internes ?**
R : Vérifiez la période et le périmètre de comparaison. Nos données incluent l'autoconsommation, ce qui peut créer des écarts avec certaines sources. Contactez support@... pour réconciliation détaillée.

**Q : Comment interpréter un facteur de charge de 14% ?**
R : C'est la moyenne nationale française. Bon indicateur : Sud > 16%, Nord ~12%. Dépend de l'ensoleillement local et qualité des installations.

**Q : Les données sont-elles mises à jour en temps réel ?**
R : Non, mise à jour mensuelle pour les données officielles (RTE, ODRE). Les estimations provisoires sont hebdomadaires.

[20+ questions FAQ anticipées...]

---

## 2. DICTIONNAIRE DE DONNÉES

### 📋 Catalogue des Indicateurs

#### CATÉGORIE : CAPACITÉ & INSTALLATIONS

**Puissance Installée Cumulée**
- **Source :** RTE - Registre national installations
- **Fraîcheur :** J+30 (publication mensuelle officielle)
- **Formule métier :** Σ(Puissance de chaque installation raccordée)
- **Granularité :** National, Régional, Départemental, Communal
- **Limites :** Exclut installations < 3kW et autoconsommation pure
- **Précision :** ±2% (estimations pour DOM-TOM)

**Nombre d'Installations Actives**
- **Source :** RTE + Enedis (données croisées)
- **Fraîcheur :** J+45 (consolidation multi-sources)
- **Formule métier :** Compte des installations raccordées - déconnectées
- **Granularité :** National, Régional, Départemental
- **Limites :** Retard signalement déconnexions (≈6 mois)
- **Précision :** ±5% sur petites installations

[Continuer pour tous les indicateurs...]

---

## 3. GUIDE D'ADMINISTRATION TECHNIQUE

### 🏗️ Architecture de la Solution

#### Composants Principaux
```
[Sources Externes] → [Snowflake DW] → [Power BI] → [Utilisateurs]
      ↓                    ↓              ↓
   RTE/ODRE/Enedis    Transformation   Dashboard
```

**Snowflake Data Warehouse :**
- Instance : `OBSERVATOIRE_PV.EU-WEST-1`
- Databases : `STAGING`, `DWH`, `MARTS`
- Warehouse : `COMPUTE_WH_M` (auto-suspend 10min)

**Power BI Premium :**
- Workspace : "Observatoire PV Production"
- Refresh : Quotidien 6h00 + Hebdomadaire dimanche 2h00
- Utilisateurs : 50 licences Pro + accès invité

#### Flux de Données Détaillé
1. **Ingestion (daily 02:00)** : APIs RTE/ODRE → Tables staging
2. **Transformation (daily 03:00)** : Staging → Tables dimensionnelles
3. **Agrégation (daily 04:00)** : Calcul KPIs → Tables marts
4. **Publication (daily 06:00)** : Refresh Power BI + notifications

### 📊 Procédures de Mise à Jour

#### Mise à Jour Mensuelle (Données Officielles)
```sql
-- Procédure automatisée d'ingestion RTE
EXEC SP_INGEST_RTE_MONTHLY 
    @start_date = '2024-01-01',
    @end_date = '2024-01-31',
    @validate_quality = TRUE;

-- Contrôles post-ingestion
SELECT * FROM VW_QUALITY_CHECKS_MONTHLY 
WHERE status = 'FAIL';
```

#### Mise à Jour Hebdomadaire (Estimations)
- **Trigger :** Tous les lundis 08:00
- **Source :** APIs ODRE données provisoires  
- **Validation :** Écart < 10% vs données précédentes
- **Action si échec :** Email équipe + maintien données N-1

### 🔍 Monitoring et Surveillance

#### KPIs de Santé Plateforme
- **Fraîcheur données :** < 48h pour sources critiques
- **Performance requêtes :** 95% < 5 secondes
- **Disponibilité :** > 99.5% sur heures ouvrées (8h-20h)
- **Erreurs qualité :** 0 erreur critique, < 5 warnings/mois

#### Alertes Configurées
| Alerte | Seuil | Action | Destinataire |
|--------|-------|---------|--------------|
| Données obsolètes | >72h | Email + SMS | Admin IT |
| Performance dégradée | >10s sur KPI | Email | Équipe Data |
| Échec ingestion | 2 échecs consécutifs | Appel + Email | Astreinte |
| Anomalie métier | Écart >20% vs attendu | Email | Responsable métier |

### 🚨 Gestion des Incidents Courants

#### Incident #1 : "Dashboard n'affiche pas les dernières données"
**Diagnostic :**
1. Vérifier date dernière mise à jour : `SELECT MAX(date_maj) FROM FACT_PRODUCTION`
2. Contrôler statut jobs Snowflake : `SHOW TASKS IN SCHEMA MARTS`
3. Vérifier refresh Power BI : Workspace → Paramètres → Actualisation

**Actions :**
- Si < 48h : Normal, attendre cycle suivant
- Si > 48h : Forcer refresh manuel ou escalader

#### Incident #2 : "Erreur lors de l'export PDF"
**Causes courantes :**
- Volume données trop important (>10k lignes)
- Timeout connexion réseau
- Droits utilisateur insuffisants

**Solutions :**
- Réduire périmètre temporal/géographique
- Utiliser export Excel puis conversion locale
- Vérifier licences Power BI utilisateur

### 📞 Contacts Support et Escalade

#### Niveau 1 - Support Fonctionnel
- **Email :** support-observatoire@[entreprise].com
- **Délai réponse :** 4h ouvrées
- **Périmètre :** Questions usage, formation, exports

#### Niveau 2 - Support Technique
- **Email :** tech-observatoire@[entreprise].com
- **Téléphone :** +33 1 XX XX XX XX (urgences uniquement)
- **Délai réponse :** 2h ouvrées
- **Périmètre :** Incidents données, performance, bugs

#### Niveau 3 - Escalade Critique
- **Contact :** Responsable Projet Data - [Nom] ([email])
- **Déclenchement :** Perte données, indisponibilité >4h
- **SLA :** 30 minutes 24/7

---

## 4. GUIDE DE MAINTENANCE ET ÉVOLUTION

### ➕ Ajouter de Nouveaux KPIs

#### Processus Standard (Délai : 2-3 semaines)
1. **Cahier des charges** : Définition métier + formule calcul
2. **Impact assessment** : Données nécessaires + effort développement  
3. **Développement** : SQL + tests + documentation
4. **Recette** : Validation métier + performance
5. **Déploiement** : Mise en production + formation utilisateurs

#### Template de Demande KPI
```markdown
## DEMANDE NOUVEAU KPI

**Nom :** [Nom explicite du KPI]
**Demandeur :** [Nom + fonction]
**Date demande :** [JJ/MM/AAAA]
**Priorité :** [P0/P1/P2]

**Définition métier :**
[Explication en langage business]

**Formule de calcul :**
[Description mathématique précise]

**Sources de données :**
- Source 1 : [nom] - [disponibilité]
- Source 2 : [nom] - [disponibilité]

**Granularité souhaitée :**
- Temporelle : [mensuel/trimestriel/annuel]
- Géographique : [national/régional/départemental]

**Cas d'usage :**
[Comment sera utilisé ce KPI]

**Seuils d'alerte :**
[Valeurs qui nécessitent attention]
```

### 📈 Intégration Nouvelles Sources

#### Sources Prioritaires Identifiées
- **SER (Syndicat EnR)** : Données marché, prix
- **CRE** : Tarifs, réglementation
- **Météo-France** : Ensoleillement, prévisions
- **INSEE** : Données socio-économiques territoriales

#### Processus d'Intégration (Délai : 4-6 semaines)
1. **Analyse source** : Format, API, fréquence, fiabilité
2. **Architecture** : Extension modèle données + ETL
3. **Développement** : Connecteurs + transformations
4. **Tests** : Qualité + performance + intégration
5. **Documentation** : Mise à jour guides utilisateur

### 🔧 Modifications Calculs Existants

#### Cas de Modification Autorisés
- ✅ Correction bugs (écarts vs références officielles)
- ✅ Ajustements précision (nouvelles sources plus fiables)  
- ✅ Optimisations performance (même résultat)
- ❌ Changement définition métier (nécessite validation comité)

#### Procédure de Modification
1. **Impact analysis** : KPIs affectés + utilisateurs impactés
2. **Tests parallèle** : Ancien vs nouveau calcul sur historique
3. **Validation métier** : Écarts acceptables < 5%
4. **Communication** : Annonce changement 1 semaine avant
5. **Déploiement** : Mise en production + monitoring renforcé

### 💾 Sauvegarde et Restauration

#### Stratégie de Sauvegarde
- **Données brutes** : Retention 7 ans (compliance)
- **Données transformées** : Backup journalier, retention 2 ans
- **Configuration** : Git + backup automatique code/scripts
- **Dashboard** : Export Power BI mensuel + sauvegarde workspace

#### Procédure de Restauration
```sql
-- Restauration données à date donnée
RESTORE DATABASE OBSERVATOIRE_PV 
FROM BACKUP = 'backup_20240315_02h00'
TO TIMESTAMP = '2024-03-15 02:00:00';

-- Vérification intégrité post-restauration
EXEC SP_CHECK_DATA_INTEGRITY;
```

---

## 5. ANNEXES TECHNIQUES

### 📊 Modèle de Données Détaillé

#### Tables Principales
```sql
-- Table de faits centrale
FACT_PRODUCTION (
    date_key NUMBER(8,0),           -- YYYYMMDD
    region_key NUMBER(4,0),         -- Clé région
    installation_key NUMBER(10,0),  -- Clé installation
    production_mwh NUMBER(10,2),    -- Production MWh
    puissance_mw NUMBER(8,2),       -- Puissance MW
    facteur_charge NUMBER(5,4),     -- Ratio production/capacité
    
    -- Métadonnées
    date_maj TIMESTAMP_NTZ,
    source_donnee VARCHAR(20),
    qualite_donnee VARCHAR(10)      -- 'REEL', 'ESTIME', 'PROJET'
);

-- Dimension géographique
DIM_GEOGRAPHIE (
    region_key NUMBER(4,0) PRIMARY KEY,
    code_region VARCHAR(3),         -- Code INSEE région
    nom_region VARCHAR(50),
    code_dept VARCHAR(3),           -- Code département  
    nom_dept VARCHAR(50),
    population NUMBER(10,0),        -- Habitants (INSEE)
    superficie_km2 NUMBER(10,2),    -- Superficie
    
    -- SCD Type 1
    date_creation DATE,
    date_modification DATE
);
```

### 📚 Dictionnaire Tables Snowflake

| Table | Type | Lignes | Description | Refresh |
|-------|------|---------|-------------|---------|
| `STG_RTE_INSTALLATIONS` | Staging | ~50k | Données brutes RTE | Mensuel |
| `STG_ODRE_PRODUCTION` | Staging | ~2M | Données brutes ODRE | Hebdomadaire |
| `DIM_TEMPS` | Dimension | ~4k | Calendrier 2012-2030 | Annuel |
| `DIM_GEOGRAPHIE` | Dimension | ~15 | Régions françaises | Ad-hoc |
| `FACT_PRODUCTION` | Fait | ~10M | Production par installation/mois | Quotidien |
| `MART_KPI_NATIONAL` | Mart | ~200 | KPIs agrégés France | Quotidien |

### 🔍 Scripts Requêtes Utiles

#### Production par Région (Top 10)
```sql
SELECT 
    dg.nom_region,
    SUM(fp.production_mwh) as production_totale_gwh,
    ROUND(AVG(fp.facteur_charge) * 100, 1) as facteur_charge_pct,
    COUNT(DISTINCT fp.installation_key) as nb_installations
FROM FACT_PRODUCTION fp
JOIN DIM_GEOGRAPHIE dg ON fp.region_key = dg.region_key
JOIN DIM_TEMPS dt ON fp.date_key = dt.date_key
WHERE dt.annee = 2024
GROUP BY dg.nom_region
ORDER BY production_totale_gwh DESC
LIMIT 10;
```

#### Évolution Mensuelle France
```sql
SELECT 
    dt.annee,
    dt.mois,
    SUM(fp.production_mwh)/1000 as production_gwh,
    SUM(fp.puissance_mw) as puissance_cumulee_mw
FROM FACT_PRODUCTION fp
JOIN DIM_TEMPS dt ON fp.date_key = dt.date_key
WHERE dt.date_complete >= '2020-01-01'
GROUP BY dt.annee, dt.mois
ORDER BY dt.annee, dt.mois;
```

### 📝 Changelog et Versions

#### Version 1.2 (2024-03-15)
- ✅ Ajout KPI "Densité installations par habitant"
- ✅ Intégration source CRE (tarifs d'achat)
- 🐛 Correction calcul facteur de charge (autoconsommation)
- 📊 Nouveau dashboard "Analyse concurrentielle"

#### Version 1.1 (2024-02-01)  
- ✅ Extension périmètre DOM-TOM
- ✅ Alertes automatiques par email
- 🐛 Fix performance requêtes historiques
- 📚 Documentation utilisateur enrichie

#### Version 1.0 (2024-01-15)
- 🎉 Version initiale de production
- 📊 Dashboard principal opérationnel
- 🔄 Pipeline données automatisé
- 👥 Formation équipe réalisée

---

**Document rédigé par :** [Équipe Projet] | **Dernière mise à jour :** [Date] | **Version :** 1.0
**Contact :** documentation@[entreprise].com | **Feedback :** [Lien formulaire]
```

## 💡 Conseils de Rédaction

### Style et Ton
- **Professionnel mais accessible** : Éviter jargon technique excessif
- **Actionnable** : Chaque section doit permettre une action concrète
- **Exemples concrets** : Toujours illustrer avec des cas réels
- **Visuellement structuré** : Utiliser émojis, tableaux, encadrés

### Validation de Qualité
- **Test utilisateur** : Faire valider par un non-technicien
- **Cohérence** : Vérifier alignement avec les KPIs définis en Phase 1
- **Complétude** : Couvrir tous les cas d'usage identifiés
- **Maintenabilité** : Documentation facile à mettre à jour

Cette activité est cruciale car elle détermine l'autonomie future du client et la réduction du support post-livraison !
