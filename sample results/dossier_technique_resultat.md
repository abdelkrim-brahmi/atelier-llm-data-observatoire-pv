# Observatoire Photovoltaïque France - Dossier de Conception Technique

## Synthèse Exécutive

L'observatoire photovoltaïque constitue un outil stratégique décisionnel permettant à l'entreprise de développer son activité dans le secteur solaire français. Cette plateforme analytique centralisera l'intelligence de marché, l'analyse territoriale et le benchmarking concurrentiel pour optimiser les investissements et saisir les opportunités de croissance.

---

# 1. VISION & OBJECTIFS

## 1.1 Enjeux Business de l'Observatoire

### Contexte Marché
Le marché photovoltaïque français connaît une croissance soutenue avec des objectifs de 35-44 GW installés d'ici 2028 selon la PPE. Cette dynamique génère de nombreuses opportunités mais nécessite une vision fine des évolutions territoriales, réglementaires et concurrentielles.

### Enjeux Stratégiques
- **Optimisation des investissements** : Identifier les zones géographiques à fort potentiel de développement
- **Anticipation réglementaire** : Suivre les évolutions des dispositifs de soutien (obligation solaire, appels d'offres CRE)
- **Intelligence concurrentielle** : Analyser les stratégies des acteurs clés du marché
- **Aide à la décision** : Fournir des indicateurs fiables pour les comités de direction
- **Accélération commerciale** : Cibler les prospects et partenaires prioritaires

## 1.2 Utilisateurs Cibles et Cas d'Usage

### Profils Utilisateurs

**Direction Générale & Stratégie**
- Tableaux de bord exécutifs sur les tendances de marché
- Analyses de positionnement concurrentiel
- Projections de croissance sectorielle

**Direction Développement**
- Cartographies des opportunités territoriales
- Analyses de potentiel par segment (résidentiel, tertiaire, sol)
- Suivi des appels d'offres et attributions

**Direction Commerciale**
- Identification des zones de prospection prioritaires
- Profils des donneurs d'ordre potentiels
- Benchmark tarifaire et positionnement prix

**Équipes Techniques**
- Analyses de productivité par zones géographiques
- Évolution des technologies et rendements
- Contraintes réseaux et raccordements

### Cas d'Usage Prioritaires
1. **Analyse territoriale** : "Quelles sont les 3 régions les plus attractives pour notre développement ?"
2. **Veille concurrentielle** : "Quelle est la stratégie de développement de nos 5 principaux concurrents ?"
3. **Opportunités commerciales** : "Quels projets > 1MW sont en cours d'instruction dans un rayon de 50km ?"
4. **Benchmark tarifaire** : "Quel est le prix moyen €/Wc par segment et par région ?"

## 1.3 KPIs de Succès du Projet

### Indicateurs d'Usage
- **Taux d'adoption** : >80% des utilisateurs cibles connectés mensuellement
- **Engagement** : >15 sessions par utilisateur/mois en moyenne
- **Couverture fonctionnelle** : 100% des cas d'usage prioritaires couverts

### Indicateurs de Qualité
- **Fraîcheur des données** : <7 jours pour les données critiques
- **Disponibilité** : >99,5% de disponibilité sur les heures ouvrées
- **Performance** : <3 secondes de temps de réponse des tableaux de bord

### Indicateurs Business
- **ROI** : Retour sur investissement mesurable dans les 18 mois
- **Décisions éclairées** : 100% des décisions d'investissement >1M€ s'appuyant sur l'observatoire
- **Opportunités identifiées** : >50 nouvelles opportunités qualifiées par trimestre

---

# 2. ARCHITECTURE FONCTIONNELLE

## 2.1 Schéma des Flux de Données

```
SOURCES EXTERNES                COLLECTE & INGESTION              TRAITEMENT                RESTITUTION
┌─────────────────┐            ┌───────────────────┐            ┌──────────────┐         ┌─────────────────┐
│ Open Data       │───────────▶│ API Connectors    │───────────▶│ Data Lake    │────────▶│ Dashboards      │
│ • data.gouv.fr  │            │ • REST/SOAP       │            │ • Raw Data   │         │ • PowerBI/Tableau│
│ • ENEDIS        │            │ • Batch ETL       │            │ • Bronze     │         │ • Web App       │
│ • RTE           │            │ • Real-time       │            │              │         │                 │
└─────────────────┘            └───────────────────┘            └──────────────┘         └─────────────────┘

┌─────────────────┐            ┌───────────────────┐            ┌──────────────┐         ┌─────────────────┐
│ Web Scraping    │───────────▶│ Data Quality      │───────────▶│ Data Warehouse│────────▶│ APIs            │
│ • Sites CRE     │            │ • Validation      │            │ • Silver     │         │ • REST/GraphQL  │
│ • Appels offres │            │ • Déduplication   │            │ • Gold       │         │ • Mobile App    │
│ • Actualités    │            │ • Enrichissement  │            │              │         │                 │
└─────────────────┘            └───────────────────┘            └──────────────┘         └─────────────────┘

┌─────────────────┐            ┌───────────────────┐            ┌──────────────┐         ┌─────────────────┐
│ Données Métier  │───────────▶│ Orchestration     │───────────▶│ Data Marts   │────────▶│ Alertes         │
│ • CRM           │            │ • Apache Airflow  │            │ • Territoires│         │ • Email/Slack   │
│ • ERP           │            │ • Planification   │            │ • Concurrence│         │ • Notifications │
│ • Fichiers Excel│            │ • Monitoring      │            │ • Projets    │         │                 │
└─────────────────┘            └───────────────────┘            └──────────────┘         └─────────────────┘
```

## 2.2 Briques Techniques Recommandées

### Couche Ingestion
- **Apache Kafka** : Streaming temps réel pour les flux critiques
- **Apache Airflow** : Orchestration des pipelines batch
- **Scrapy/BeautifulSoup** : Web scraping des sources publiques
- **Talend/Pentaho** : ETL pour les connecteurs complexes

### Couche Stockage & Traitement
- **Data Lake** : Azure Data Lake Storage Gen2 ou AWS S3
- **Data Warehouse** : Snowflake ou Azure Synapse Analytics
- **Compute** : Apache Spark sur Databricks
- **Base NoSQL** : MongoDB pour données non-structurées

### Couche Restitution
- **BI** : Power BI Premium ou Tableau Server
- **Web App** : React.js + Node.js pour interfaces custom
- **API** : FastAPI (Python) ou Spring Boot (Java)
- **Cache** : Redis pour les performances

### Infrastructure & DevOps
- **Cloud** : Microsoft Azure ou AWS (recommandé Azure pour intégration Office 365)
- **Containers** : Docker + Kubernetes
- **CI/CD** : Azure DevOps ou GitLab CI
- **Monitoring** : Prometheus + Grafana + ELK Stack

## 2.3 Contraintes et Exigences Non-Fonctionnelles

### Performance
- **Latence** : <3s pour les dashboards interactifs, <10s pour les requêtes complexes
- **Débit** : Support de 50 utilisateurs simultanés en pic
- **Volumétrie** : Gestion de 100GB+ de données historiques, croissance 20GB/an

### Sécurité & Conformité
- **Authentification** : SSO avec Active Directory, MFA obligatoire
- **Autorisation** : RBAC granulaire par profil utilisateur
- **Chiffrement** : Données at rest et in transit (AES-256, TLS 1.3)
- **RGPD** : Conformité pour les données personnelles (audit trail, droit à l'oubli)

### Disponibilité & Fiabilité
- **SLA** : 99,5% de disponibilité sur heures ouvrées (7h-19h)
- **RTO** : <4h pour restauration complète
- **RPO** : <1h de perte de données maximale
- **Sauvegarde** : 3-2-1 (3 copies, 2 supports, 1 site distant)

### Évolutivité
- **Scalabilité** : Architecture cloud-native auto-scalante
- **Extensibilité** : APIs pour intégration de nouvelles sources
- **Maintenabilité** : Code documenté, tests automatisés, monitoring

---

# 3. MODÈLE DE DONNÉES CONCEPTUEL

## 3.1 Entités Principales et Relations

```
TERRITOIRE                      INSTALLATION                    ACTEUR
┌─────────────────┐            ┌──────────────────┐           ┌─────────────────┐
│ id_territoire   │            │ id_installation  │           │ id_acteur       │
│ nom             │            │ puissance_kwc    │           │ nom             │
│ type            │◄──────────►│ date_mes         │◄─────────►│ type            │
│ coordonnees     │            │ technologie      │           │ siret           │
│ population      │            │ tarif_rachat     │           │ chiffre_affaire │
│ pib_habitant    │            │ statut           │           │ nb_employes     │
└─────────────────┘            │ id_territoire    │           └─────────────────┘
         │                     │ id_proprietaire  │                    │
         │                     │ id_exploitant    │                    │
         ▼                     └──────────────────┘                    ▼
┌─────────────────┐                     │                    ┌─────────────────┐
│ POTENTIEL       │                     ▼                    │ PROJET          │
│ irradiation_kwh │            ┌──────────────────┐          │ id_projet       │
│ contrainte_reseau│           │ PRODUCTION       │          │ nom_projet      │
│ zone_plu        │            │ id_installation  │          │ puissance_prev  │
│ foncier_dispo   │            │ date_releve      │          │ date_depot      │
└─────────────────┘            │ production_kwh   │          │ statut_instruction│
                              │ irradiation      │          │ id_porteur      │
                              └──────────────────┘          └─────────────────┘
```

### Relations Clés
- **TERRITOIRE ↔ INSTALLATION** : 1 territoire contient N installations (1:N)
- **ACTEUR ↔ INSTALLATION** : 1 acteur peut posséder/exploiter N installations (1:N)
- **INSTALLATION ↔ PRODUCTION** : 1 installation génère N relevés de production (1:N)
- **TERRITOIRE ↔ POTENTIEL** : 1 territoire a 1 profil de potentiel (1:1)
- **ACTEUR ↔ PROJET** : 1 acteur peut porter N projets (1:N)

## 3.2 Granularité Temporelle et Géographique

### Granularité Temporelle
- **Données de production** : Mensuelle (agrégation possible quotidienne pour monitoring)
- **Données économiques** : Trimestrielle avec historique 5 ans minimum
- **Données projets** : Temps réel avec snapshot mensuel pour historique
- **Indicateurs de marché** : Mensuelle avec mise à jour hebdomadaire

### Granularité Géographique
- **Niveau 1 - National** : Indicateurs macro, benchmark européen
- **Niveau 2 - Régional** : Analyses de potentiel, politiques régionales
- **Niveau 3 - Départemental** : Suivi détaillé des installations et projets
- **Niveau 4 - Communal** : Cartographie fine, opportunités locales
- **Niveau 5 - Parcellaire** : Pour projets >100kWc uniquement

### Dimensions d'Analyse
- **Temporelle** : Année, trimestre, mois, semaine
- **Géographique** : Région, département, EPCI, commune
- **Technologique** : Silicium cristallin, couches minces, bifacial
- **Segmentaire** : Résidentiel, tertiaire, industriel, centrales sol
- **Acteur** : Installateur, développeur, investisseur, exploitant

## 3.3 Règles de Gestion Métier

### Règles de Calcul
1. **Productible théorique** = Puissance × Irradiation × Performance Ratio (0.85 par défaut)
2. **Densité d'installation** = Puissance totale / Population (Wc/habitant)
3. **Taux de pénétration** = Nombre installations / Nombre bâtiments éligibles
4. **Prix moyen** = Chiffre d'affaires total / Puissance installée (€/Wc)

### Règles de Qualité
- **Installation valide** : Puissance > 1kWc ET Date MES ≤ Date du jour
- **Production cohérente** : 800 ≤ Productivité ≤ 1800 kWh/kWc/an (selon région)
- **Acteur consolidé** : Regroupement par SIREN des entités liées
- **Territoire normalisé** : Code INSEE obligatoire + contrôle intégrité

### Règles de Confidentialité
- **Installations <9kWc** : Agrégation minimale par IRIS INSEE
- **Données financières** : Accès restreint Direction uniquement
- **Projets concurrents** : Anonymisation des porteurs de projets
- **Données personnelles** : Chiffrement + audit trail obligatoires

---

# 4. PLANNING MACRO

## 4.1 Phases du Projet avec Jalons

### Phase 1 - Cadrage & Architecture Détaillée (2 mois)
**Objectifs** : Finaliser les spécifications, valider l'architecture technique, préparer l'environnement

**Livrables** :
- Spécifications fonctionnelles détaillées
- Architecture technique finalisée
- Environnements cloud provisionnés
- Équipe projet constituée

**Jalons** :
- J+30 : Validation des spécifications
- J+60 : Go/No-Go architecture technique

### Phase 2 - MVP & Sources de Données Critiques (3 mois)
**Objectifs** : Implémenter les fonctionnalités core, connecter les sources prioritaires

**Livrables** :
- Data Lake opérationnel
- Connexion aux 3 sources principales (ENEDIS, RTE, CRE)
- Premier dashboard territorial
- API de base fonctionnelle

**Jalons** :
- J+90 : Première ingestion de données
- J+120 : MVP démontrable
- J+150 : Recette utilisateur MVP

### Phase 3 - Extension Fonctionnelle (2 mois)
**Objectifs** : Enrichir les fonctionnalités, ajouter les sources secondaires

**Livrables** :
- Web scraping opérationnel
- Module de veille concurrentielle
- Dashboards avancés (5 minimum)
- Système d'alertes

**Jalons** :
- J+180 : Fonctionnalités étendues déployées
- J+210 : Tests de charge validés

### Phase 4 - Finalisation & MEP (1 mois)
**Objectifs** : Finaliser, sécuriser, former, mettre en production

**Livrables** :
- Tests de sécurité passés
- Documentation utilisateur
- Formations dispensées
- Production opérationnelle

**Jalons** :
- J+225 : Go/No-Go mise en production
- J+240 : MEP et GVDS

## 4.2 Estimation des Charges par Lot

### Lot 1 - Infrastructure & Data Engineering (45 j.h)
- Architecte Cloud Senior : 15 j.h
- Data Engineer Senior : 20 j.h  
- DevOps : 10 j.h

### Lot 2 - Développement Backend & APIs (35 j.h)
- Tech Lead Backend : 15 j.h
- Développeur Python/Java : 20 j.h

### Lot 3 - Interface & Visualisation (30 j.h)
- UX/UI Designer : 10 j.h
- Développeur Frontend : 15 j.h
- Expert BI : 5 j.h

### Lot 4 - Data Science & Intelligence (20 j.h)
- Data Scientist : 15 j.h
- Expert Métier PV : 5 j.h

### Lot 5 - Sécurité & Conformité (15 j.h)
- Expert Cybersécurité : 10 j.h
- Expert RGPD : 5 j.h

**TOTAL ESTIMÉ : 145 jours.homme**

### Répartition Budgétaire Indicative
- **Équipe projet** : 60% (personnel, prestations)
- **Infrastructure cloud** : 20% (licences, compute, stockage)
- **Outils & licences** : 15% (BI, ETL, monitoring)
- **Contingence** : 5%

## 4.3 Risques et Dépendances Critiques

### Risques Techniques (Probabilité × Impact)

**ÉLEVÉ**
- **Qualité des sources externes** (80% × Fort) : Données incomplètes/erronnées des organismes publics
  - *Mitigation* : Sources multiples + règles de validation + alertes qualité

- **Performance sur gros volumes** (60% × Fort) : Lenteurs avec croissance des données
  - *Mitigation* : Architecture scalable + tests de charge + optimisation requêtes

**MOYEN**  
- **Complexité web scraping** (70% × Moyen) : Anti-bot, changements de structure sites
  - *Mitigation* : Proxies rotatifs + monitoring + plans de contournement

- **Montée en compétence équipe** (50% × Moyen) : Technologies cloud nouvelles pour l'équipe
  - *Mitigation* : Formation anticipée + accompagnement expert + documentation

**FAIBLE**
- **Sécurité & cyberattaques** (20% × Fort) : Tentatives d'intrusion, fuite de données
  - *Mitigation* : Audit sécurité + monitoring + plan de réponse incident

### Dépendances Critiques

**BLOQUANTES**
1. **Validation budgétaire** : Budget >500k€ nécessite validation COMEX (Délai : 4 semaines)
2. **Accès données ENEDIS** : Convention d'accès aux données (Délai : 8-12 semaines)
3. **Environnement cloud** : Validation DSI + Security Officer (Délai : 6 semaines)

**IMPORTANTES**  
4. **Ressources internes** : Disponibilité expert métier PV à 50% minimum
5. **Validation RGPD** : Avis DPO sur traitement données (Délai : 3 semaines)
6. **Intégration SI existant** : APIs CRM/ERP disponibles et documentées

### Plan de Contingence
- **Retard sources externes** : Démarrage avec open data + intégration différée
- **Dépassement budget** : Priorisation fonctionnalités + MEP phasée
- **Indisponibilité expertise** : Recours prestataire spécialisé énergie
- **Problèmes performance** : Migration vers architecture serverless

---

## Conclusion & Prochaines Étapes

L'observatoire photovoltaïque représente un investissement stratégique clé pour accélérer le développement de l'activité solaire. L'architecture proposée garantit évolutivité, performance et sécurité tout en répondant aux besoins utilisateurs identifiés.

### Actions Immédiates Recommandées
1. **Validation du dossier** par le Comité de Direction
2. **Lancement des démarches administratives** (accès données, environnement cloud)
3. **Constitution de l'équipe projet** et recrutement des compétences manquantes
4. **Négociation des accords** avec les fournisseurs de données

### Facteurs Clés de Succès
- **Sponsoring Direction** forte et continue
- **Expertise métier** photovoltaïque intégrée au projet
- **Approche agile** avec livraisons itératives
- **Conduite du changement** et adoption utilisateurs

*Ce dossier constitue la base de travail pour le lancement du projet. Il sera affiné lors de la phase de cadrage détaillée.*