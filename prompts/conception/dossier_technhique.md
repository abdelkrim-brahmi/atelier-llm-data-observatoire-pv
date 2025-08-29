# Activité 1.1 : Dossier de Conception Technique

## 🎯 Contexte d'Usage
Produire rapidement un dossier de conception technique professionnel pour initialiser un projet Data et le lancer efficacement.

## ⏱️ Temps Alloué
20 minutes

## 👤 Votre Rôle
Data Architect senior avec expertise projets énergétiques

## 📄 Livrable Attendu
Document de conception de 3-4 pages structuré et prêt pour présentation client

## 🤖 Prompt à Copier-Coller

```
Agis comme un Data Architect senior avec 10 ans d'expérience. 

CONTEXTE : Je dois concevoir un observatoire du photovoltaïque en France pour une entreprise énergétique qui veut développer son activité dans ce secteur de manière stratégique. Cet observatoire servira à analyser les tendances de marché, identifier les opportunités territoriales et benchmarker la concurrence.

MISSION : Produis-moi un dossier de conception technique structuré incluant :

1. VISION & OBJECTIFS
   - Enjeux business de l'observatoire
   - Utilisateurs cibles et cas d'usage
   - KPIs de succès du projet

2. ARCHITECTURE FONCTIONNELLE  
   - Schéma des flux de données (source → traitement → restitution)
   - Briques techniques recommandées
   - Contraintes et exigences non-fonctionnelles

3. MODÈLE DE DONNÉES CONCEPTUEL
   - Entités principales et relations
   - Granularité temporelle et géographique
   - Règles de gestion métier

4. PLANNING MACRO
   - Phases du projet avec jalons
   - Estimation des charges par lot
   - Risques et dépendances critiques

Format de sortie : Document structuré avec titres H1/H2, prêt pour un client.
```

## ✅ Critères de Validation

- [ ] Le document fait 3-4 pages minimum
- [ ] Architecture technique cohérente avec les enjeux
- [ ] Planning réaliste avec estimation charges
- [ ] Identification des risques techniques et métier

## 💡 Bonnes Pratiques Illustrées

- ✅ **Contexte détaillé** en début de prompt
- ✅ **Rôle et expertise** précisés dès le départ
- ✅ **Structure de sortie** demandée explicitement
- ✅ **Niveau de détail** ajusté à l'audience (client)

## 🔄 Prompt de Raffinement (si nécessaire)

```
Le document est bien mais trop générique. Personnalise-le davantage :
- Ajoute des références spécifiques au marché français du photovoltaïque
- Précise les sources de données publiques disponibles (RTE, Enedis, etc.)
- Adapte le planning pour un projet de 6 mois avec 3 profils techniques
- Inclus des exemples de KPIs sectoriels concrets
```

## 🛠️ Prompts Avancés pour Personnalisation

### Adaptation selon le Type de Client

#### Pour un Installateur PV
```
Adapte ce dossier de conception pour un installateur photovoltaïque qui cherche :
- À identifier les territoires avec le meilleur potentiel commercial
- À optimiser sa stratégie de prospection par segment (résidentiel/tertiaire)
- À benchmarker ses performances vs concurrence locale
- À anticiper l'évolution réglementaire et tarifaire
```

#### Pour un Investisseur/Fonds
```
Réoriente la conception pour un fonds d'investissement spécialisé EnR :
- Focus sur les métriques de rentabilité et ROI par typologie de projets
- Analyse de risque géographique et réglementaire
- Outils de due diligence pour l'acquisition de portefeuilles PV
- Benchmarks de performance vs indices sectoriels
```

#### Pour une Collectivité
```
Personnalise pour une région/département qui souhaite :
- Piloter sa stratégie de transition énergétique territoriale
- Mesurer l'atteinte des objectifs SRADDET/PCAET
- Identifier les freins au développement PV local
- Optimiser les dispositifs d'aide et d'accompagnement
```

### Enrichissement Technique

#### Architecture Cloud-Native
```
Enrichis la section architecture technique avec :
- Recommandations d'architecture cloud (AWS/Azure/GCP)
- Services managés optimaux pour les données énergétiques
- Stratégie multi-zone et disaster recovery
- Intégration avec les APIs des opérateurs énergétiques français
- Coûts d'infrastructure prévisionnels sur 3 ans
```

#### Gouvernance et Sécurité
```
Ajoute une section gouvernance des données incluant :
- Conformité RGPD et confidentialité des données énergétiques
- Gestion des droits d'accès par profil utilisateur
- Traçabilité et audit des transformations de données
- Stratégie de sauvegarde et archivage long terme
- Procédures de qualité et validation des données
```

## 📋 Template de Structure Attendue

```markdown
# DOSSIER DE CONCEPTION - OBSERVATOIRE PHOTOVOLTAÏQUE

## 1. VISION & OBJECTIFS STRATÉGIQUES

### 1.1 Enjeux Business
- Positionnement concurrentiel sur le marché PV français (45 GW d'objectifs PPE 2028)
- Optimisation des investissements par identification des zones à fort potentiel
- [...]

### 1.2 Utilisateurs Cibles
- **Dirigeants** : Vision stratégique et pilotage des investissements
- **Directeurs Commerciaux** : Ciblage territorial et opportunités marché
- [...]

### 1.3 KPIs de Succès Projet
- Réduction de 30% du time-to-market pour les nouvelles implantations
- Amélioration de 15% du ROI des investissements territoriaux
- [...]

## 2. ARCHITECTURE FONCTIONNELLE

### 2.1 Flux de Données
```
[Sources] → [Ingestion] → [Transformation] → [Stockage] → [Restitution]
```

### 2.2 Stack Technique Recommandé
- **Ingestion** : Snowflake + APIs publiques (RTE, ODRE)
- **Transformation** : dbt + Snowflake compute
- [...]

[etc.]
```

## ⚡ Conseils d'Optimisation

### Timing de l'Activité (20 minutes)
1. **5 min** - Lancer le prompt principal et laisser ChatGPT générer
2. **10 min** - Lire le résultat et identifier les points à personnaliser
3. **5 min** - Utiliser le prompt de raffinement pour ajuster

### Maximiser la Qualité du Résultat
- **Préciser le secteur d'activité** du client dès le prompt initial
- **Mentionner le budget approximatif** si connu (ex: "projet 200K€")
- **Indiquer les contraintes techniques** spécifiques (legacy, cloud, etc.)
- **Spécifier l'horizon temporel** (6 mois, 1 an, 3 ans)

## 🎯 Variantes de Contexte

### Projet Interne vs Prestation Client
```
Pour un projet interne :
"Je suis dans une entreprise énergétique qui développe en interne..."

Pour une prestation :
"Je suis consultant et je dois proposer à mon client [SECTEUR]..."
```

### Contraintes Budgétaires
```
Projet budget serré :
"Avec un budget contraint de 50K€, privilégie les solutions open source..."

Projet premium :
"Budget disponible de 500K€, recommande les meilleures technologies du marché..."
```

## 📊 Indicateurs de Qualité du Livrable

| Critère | Attendu | Réalisé |
|---------|---------|---------|
| **Longueur** | 3-4 pages | [ ] |
| **Structure** | 4 sections principales | [ ] |
| **Spécificité PV** | Références sectorielles | [ ] |
| **Faisabilité** | Planning réaliste | [ ] |
| **Complétude** | Tous les aspects couverts | [ ] |

## ⚠️ Pièges à Éviter

- **Dossier trop générique** : Manque de spécificité photovoltaïque
- **Architecture irréaliste** : Technologies non maîtrisées par l'équipe
- **Planning optimiste** : Sous-estimation des délais d'intégration
- **Oubli des contraintes** : Réglementaire, sécurité, budget
- **Manque de justification** : Choix techniques non argumentés

## 🚀 Extensions Possibles

Si le temps le permet ou pour approfondir :

### Étude d'Impact
```
Ajoute une analyse d'impact business quantifiée :
- ROI attendu sur 3 ans avec hypothèses détaillées
- Gains de productivité par fonction métier
- Économies générées par l'optimisation des décisions
- Risques évités grâce aux alertes précoces
```

### Benchmark Concurrentiel
```
Enrichis avec une analyse concurrentielle :
- Comparaison avec solutions existantes du marché
- Avantages différenciants de l'approche proposée
- Positionnement prix vs valeur ajoutée
- Stratégie de protection de l'avantage concurrentiel
```

Cette structure garantit un dossier de conception professionnel et convaincant en 20 minutes, parfaitement adapté au contexte de l'atelier !
