# Conception UX Dashboard - Observatoire Photovoltaïque Exécutif

## Synopsis Exécutif

Cette conception UX répond aux besoins spécifiques des dirigeants du secteur énergétique : **accès rapide à l'information stratégique**, **navigation intuitive** et **insights actionnables** en moins de 20 minutes de consultation hebdomadaire.

---

# 1. STRUCTURE GÉNÉRALE

## 1.1 Architecture de Navigation - Pyramide Inversée

```
NIVEAU 0 - SYNTHÈSE EXÉCUTIVE (Landing Page)
├── Vue 360° marché photovoltaïque français
├── 6 KPIs critiques avec alertes
└── 3 insights prioritaires de la semaine

NIVEAU 1 - ANALYSES THÉMATIQUES (4 sections principales)
├── 📊 MARCHÉ & PERFORMANCE     ├── 🗺️ TERRITORIAL & GÉOGRAPHIE
├── ⏱️ ÉVOLUTIONS & TENDANCES   └── 🏢 CONCURRENCE & OPPORTUNITÉS

NIVEAU 2 - DRILL-DOWN DÉTAILLÉ
├── Données régionales/départementales
├── Analyses temporelles fines
└── Exports et rapports personnalisés
```

## 1.2 Menu de Navigation Principal

```ascii
╔═══════════════════════════════════════════════════════════════╗
║  🏠 ACCUEIL  📊 MARCHÉ  🗺️ TERRITORIAL  ⏱️ TENDANCES  🏢 CONCURRENCE ║
║                                                    👤 [PROFIL] ║
╚═══════════════════════════════════════════════════════════════╝
```

**Principes de Navigation** :
- **Breadcrumb systematique** : Accueil > Section > Détail
- **Navigation latérale contextuelle** dans chaque section
- **Raccourcis clavier** pour utilisateurs avancés (Ctrl+1 à Ctrl+5)
- **Bookmarks** pour vues personnalisées fréquentes

## 1.3 Hiérarchie de l'Information - Règle des 3 Niveaux

### Niveau 1 - Vue d'Ensemble (5 secondes)
- **Messages clés** : 3 insights maximum avec code couleur urgent/important
- **Tendance générale** : Croissance/stagnation/déclin du marché
- **Alertes critiques** : Anomalies nécessitant attention immédiate

### Niveau 2 - Analyse Dirigeante (2-3 minutes)
- **KPIs contextualisés** : Évolution vs objectifs et benchmark
- **Analyses comparatives** : Performance vs concurrents/régions
- **Opportunités détectées** : Zones/segments à fort potentiel

### Niveau 3 - Deep Dive (10-15 minutes)
- **Données opérationnelles** : Métriques détaillées par dimension
- **Analyses de corrélation** : Facteurs explicatifs des tendances
- **Données brutes exportables** : Pour analyses approfondies

---

# 2. WIREFRAMES DES PAGES CLÉS

## 2.1 Page d'Accueil - "Mission Control"

```ascii
╔══════════════════════════════════════════════════════════════════════════╗
║                    🔋 OBSERVATOIRE PHOTOVOLTAÏQUE FRANCE                  ║
║                                                                          ║
║  ⚡ ALERTE: +12% croissance T3 vs objectif (+8%)  🔥 URGENT: Saturation ║
║             réseau Grand Est nécessite action                            ║
║                                                                          ║
║ ┌─── KPIs STRATÉGIQUES ─────────────┐ ┌─── INSIGHTS HEBDOMADAIRES ─────┐ ║
║ │                                   │ │                                │ ║
║ │  📈 Puissance Installée          │ │  💡 Nouvelle-Aquitaine dépasse │ ║
║ │      28.2 GW  ↗️ +2.1GW (Q3)      │ │     6 GW - Leader incontesté   │ ║
║ │                                   │ │                                │ ║
║ │  ⚡ Production 2024              │ │  🎯 Objectif PPE 2028: 63%     │ ║
║ │      31.8 TWh  ↗️ +18% vs 2023    │ │     réalisé (28.2/44.5 GW)     │ ║
║ │                                   │ │                                │ ║
║ │  🏠 Segment Résidentiel          │ │  📊 5 nouvelles grandes        │ ║
║ │      47% part  ↘️ -2pts vs 2023   │ │     centrales >100MW prévues   │ ║
║ │                                   │ │                                │ ║
║ │  🌍 Facteur Charge National      │ │  ⚠️ Cours silicium +15%        │ ║
║ │      14.2%     ↗️ +0.3pts         │ │     Impact coûts Q4            │ ║
║ │                                   │ │                                │ ║
║ │  💰 LCOE Moyen Résidentiel       │ │  🔍 Analyse détaillée →        │ ║
║ │      €0.089/kWh ↘️ -€0.006       │ │     [OUVRIR RAPPORT COMPLET]   │ ║
║ │                                   │ │                                │ ║
║ │  🏆 Top Région (Puissance/hab)   │ │  📅 Prochaine MAJ: Lundi 9h    │ ║
║ │      PACA: 523W/hab              │ │     Source: RTE/ENEDIS Oct 2024 │ ║
║ └───────────────────────────────────┘ └────────────────────────────────┘ ║
║                                                                          ║
║ ┌─────────────── CARTE DE CHALEUR FRANCE ───────────────────────────────┐ ║
║ │                    [Puissance installée par département]              │ ║
║ │  🟢🟢🟢     🟡🟡🟡     🔴🟠🟠🟠🟠🔴                                    │ ║
║ │  🟢🟢🟢     🟡🟡🟡     🟠🟠🟠🟠🟠🟠     Légende:                      │ ║
║ │  🟢🟢🟢     🟡🟡🟡     🟠🔴🔴🔴🔴🔴     🟢 >400W/hab (leader)         │ ║
║ │            🟡🟡🟡                     🟡 200-400W/hab (développé)     │ ║
║ │                                      🟠 100-200W/hab (croissance)    │ ║
║ │                                      🔴 <100W/hab (potentiel)        │ ║
║ └─────────────────────────────────────────────────────────────────────┘ ║
║                                                                          ║
║ ┌─── ACTIONS RAPIDES ───┐  ┌─── NAVIGATION MÉTIER ───┐                  ║
║ │ 📊 Rapport Mensuel    │  │ 🎯 Zones d'Expansion    │                  ║
║ │ 📈 Analyse Tendances  │  │ ⚔️ Veille Concurrence   │                  ║
║ │ 🗺️ Cartographie      │  │ 💼 Opportunités B2B     │                  ║
║ │ 📧 Alertes Email      │  │ 📱 Export Mobile        │                  ║
║ └───────────────────────┘  └─────────────────────────┘                  ║
╚══════════════════════════════════════════════════════════════════════════╝
```

**Temps de lecture cible** : 30-60 secondes pour identifier les points d'attention

## 2.2 Vue Géographique - "Radar Territorial"

```ascii
╔══════════════════════════════════════════════════════════════════════════╗
║                            🗺️ ANALYSE TERRITORIALE                       ║
║                                                                          ║
║ Filtres: 📅2024 🏭Tous segments 📊Puissance installée                   ║
║                                                                          ║
║ ┌────────────────── CARTE INTERACTIVE ──────────────────────────────────┐ ║
║ │                                                                        │ ║
║ │    NOUVELLE-AQUITAINE     AUVERGNE-                    PACA           │ ║
║ │         🟢 5.8GW         RHÔNE-ALPES      GRAND EST   🟡 2.9GW       │ ║
║ │         +18% 2024          🟢 2.9GW       🟡 1.7GW    523 W/hab      │ ║
║ │         341 W/hab           +22% 2024     +12% 2024   🔥LEADER🔥     │ ║
║ │                                                                        │ ║
║ │           OCCITANIE              CENTRE-VAL            BOURGOGNE      │ ║
║ │            🟢 5.1GW               🟠 0.8GW              🔴 0.5GW       │ ║
║ │            +15% 2024              +8% 2024             +25% 2024      │ ║
║ │            724 W/hab               316 W/hab           📈CROISSANCE📈  │ ║
║ │                                                                        │ ║
║ │  [Zoom +/-]  [Données]  [Heatmap: Production/Densité/Croissance]      │ ║
║ └────────────────────────────────────────────────────────────────────────┘ ║
║                                                                          ║
║ ┌─── TOP/FLOP RÉGIONS ─────────┐  ┌─── ANALYSE POTENTIEL ─────────────┐ ║
║ │                              │  │                                   │ ║
║ │ 🏆 LEADERS 2024:             │  │ 🎯 POTENTIEL INEXPLOITÉ:          │ ║
║ │ 1. Nouvelle-Aq.  5.8GW ↗️18% │  │                                   │ ║
║ │ 2. Occitanie     5.1GW ↗️15% │  │ 🔴 Hauts-de-France: 89W/hab      │ ║
║ │ 3. PACA          2.9GW ↗️11% │  │    Potentiel: +2.1GW possible     │ ║
║ │                              │  │                                   │ ║
║ │ 📉 À DÉVELOPPER:             │  │ 🔴 Île-de-France: 67W/hab         │ ║
║ │ 1. Corse         0.27GW      │  │    Barrière: Foncier disponible   │ ║
║ │ 2. Normandie     0.43GW      │  │                                   │ ║
║ │ 3. Bretagne      0.63GW      │  │ 🟠 Normandie: 175W/hab            │ ║
║ │                              │  │    Opportunité: Éolien offshore   │ ║
║ └──────────────────────────────┘  └───────────────────────────────────┘ ║
║                                                                          ║
║ ┌─────────────────── ACTIONS STRATÉGIQUES ──────────────────────────────┐ ║
║ │ 💡 3 RECOMMANDATIONS PRIORITAIRES:                                     │ ║
║ │                                                                        │ ║
║ │ 1. 🎯 CIBLAGE Hauts-de-France: Marché résidentiel sous-développé      │ ║
║ │    → Potentiel +140% vs moyenne nationale                             │ ║
║ │                                                                        │ ║
║ │ 2. ⚡ EXPANSION Bourgogne-Franche-Comté: +25% croissance observée     │ ║
║ │    → Accélération commerciale recommandée                             │ ║
║ │                                                                        │ ║
║ │ 3. 🏭 B2B Île-de-France: Focus tertiaire (résidentiel saturé)        │ ║
║ │    → Opportunité toitures industrielles/logistiques                   │ ║
║ └────────────────────────────────────────────────────────────────────────┘ ║
╚══════════════════════════════════════════════════════════════════════════╝
```

## 2.3 Analyse Temporelle - "Chronoscope"

```ascii
╔══════════════════════════════════════════════════════════════════════════╗
║                          ⏱️ ÉVOLUTIONS & TENDANCES                       ║
║                                                                          ║
║ Période: [2019▼] à [2024▼]    Granularité: [Trimestriel▼]              ║
║                                                                          ║
║ ┌───────────────── GRAPHIQUE PRINCIPAL - CROISSANCE ────────────────────┐ ║
║ │  GW                                                                    │ ║
║ │  30│                                                            ●      │ ║
║ │    │                                                         ●●        │ ║
║ │  25│                                                    ●●●●           │ ║
║ │    │                                              ●●●●●                │ ║
║ │  20│                                        ●●●●●                      │ ║
║ │    │                                  ●●●●●                            │ ║
║ │  15│                            ●●●●●                                  │ ║
║ │    │                      ●●●●●                                        │ ║
║ │  10│                ●●●●●          📊 Objectif PPE 2028: 44.5GW       │ ║
║ │    │          ●●●●●                   ⏰ Réalisé: 28.2GW (63%)         │ ║
║ │   5│    ●●●●●                         📈 Rythme actuel: +2.1GW/an     │ ║
║ │    │●●●●                              🎯 Besoin: +2.7GW/an (2025-28)  │ ║
║ │   0└─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────────    │ ║
║ │    2019  2020  2021  2022  2023  2024  2025  2026  2027  2028         │ ║
║ │                                         ▲                             │ ║
║ │                                    AUJOURD'HUI                        │ ║
║ └────────────────────────────────────────────────────────────────────────┘ ║
║                                                                          ║
║ ┌─── SAISONNALITÉ ─────────────┐  ┌─── CYCLES & PRÉDICTIONS ──────────┐ ║
║ │                              │  │                                   │ ║
║ │ Production par trimestre     │  │ 🔮 PRÉVISIONS 2025:               │ ║
║ │ (TWh, moyenne 2019-2024):    │  │                                   │ ║
║ │                              │  │ Q1: +1.8GW (hiver, installations) │ ║
║ │ T1 (Jan-Mar): 3.2 🔵██       │  │ Q2: +2.4GW (printemps, pic)      │ ║
║ │ T2 (Avr-Jun): 8.7 🟢████████ │  │ Q3: +1.9GW (été, ralentissement) │ ║
║ │ T3 (Jul-Sep): 9.1 🟡████████ │  │ Q4: +2.1GW (automne, reprise)    │ ║
║ │ T4 (Oct-Déc): 4.8 🟠███      │  │                                   │ ║
║ │                              │  │ 📊 TOTAL 2025: +8.2GW prévu      │ ║
║ │ 💡 Peak: Juillet-Août        │  │ 🎯 Objectif annuel: +2.7GW       │ ║
║ │ 🔽 Low:  Décembre-Janvier    │  │ ⚠️ SURPERFORMANCE attendue       │ ║
║ └──────────────────────────────┘  └───────────────────────────────────┘ ║
║                                                                          ║
║ ┌─────────────────── ALERTES PRÉDICTIVES ─────────────────────────────────┐ ║
║ │                                                                         │ ║
║ │ 🚨 ALERTE ROUGE - Saturation réseau prévisible T2 2025:               │ ║
║ │    Nouvelle-Aquitaine & Occitanie risquent limitations raccordements  │ ║
║ │                                                                         │ ║
║ │ 🟡 ATTENTION - Ralentissement segment résidentiel observé depuis T3:   │ ║
║ │    -5% nouvelles installations vs tendance → Impact inflation ?        │ ║
║ │                                                                         │ ║
║ │ 🟢 OPPORTUNITÉ - Segment industriel accélération +34% T4 2024:        │ ║
║ │    Anticipation fin obligation achat → Boost autoconsommation          │ ║
║ └─────────────────────────────────────────────────────────────────────────┘ ║
╚══════════════════════════════════════════════════════════════════════════╝
```

## 2.4 Benchmarks et Concurrence - "Intelligence Market"

```ascii
╔══════════════════════════════════════════════════════════════════════════╗
║                          🏢 CONCURRENCE & OPPORTUNITÉS                   ║
║                                                                          ║
║ Segment: [Résidentiel▼] Région: [Toutes▼] Métrique: [Parts de marché▼]  ║
║                                                                          ║
║ ┌─── TOP 10 ACTEURS MARCHÉ FRANÇAIS ─────────────────────────────────────┐ ║
║ │                                                                        │ ║
║ │  Rang │ Acteur              │ Part Marché │ Évol. 2024 │ CA Estimé     │ ║
║ │  ───  │ ──────              │ ────────── │ ──────────── │ ────────────   │ ║
║ │   1   │ 🔋 ENGIE Solutions   │    8.2%    │    +0.4%    │   890M€       │ ║
║ │   2   │ ⚡ EDF ENR          │    6.8%    │    +1.2%    │   740M€       │ ║
║ │   3   │ 🌟 Otovo            │    4.1%    │    +2.1%    │   445M€       │ ║
║ │   4   │ 🏠 Mon Kit Solaire  │    3.9%    │    -0.3%    │   425M€       │ ║
║ │   5   │ 🔆 Solarwatt       │    3.2%    │    +0.8%    │   350M€       │ ║
║ │  ...  │ ...                 │    ...     │    ...      │   ...         │ ║
║ │  47   │ 👤 VOTRE ENTREPRISE │    0.8%    │    +0.2%    │    87M€       │ ║
║ │                                                                        │ ║
║ │  💡 Marché très fragmenté: Top 10 = 32% seulement                     │ ║
║ └────────────────────────────────────────────────────────────────────────┘ ║
║                                                                          ║
║ ┌─── ANALYSE CONCURRENTIELLE ─────┐  ┌─── OPPORTUNITÉS DÉTECTÉES ──────┐ ║
║ │                                 │  │                                 │ ║
║ │ 🎯 POSITIONNEMENT:              │  │ 🚀 GAPS DE MARCHÉ:              │ ║
║ │                                 │  │                                 │ ║
║ │ Votre rang: #47/500+ acteurs    │  │ • Bourgogne-FC: Leader absent   │ ║
║ │ Part marché: 0.8% (stable)     │  │   → Part max concurrent: 2.1%    │ ║
║ │ Présence géo: 8/13 régions     │  │                                 │ ║
║ │                                 │  │ • Segment tertiaire 20-100kW:   │ ║
║ │ 💪 FORCES vs Concurrence:       │  │   → Croissance +45% mais        │ ║
║ │ • Prix compétitifs (-8%)       │  │     offre limitée détectée       │ ║
║ │ • Délais installation (3 sem)  │  │                                 │ ║
║ │                                 │  │ • Agrivoltaisme: Niche émergente│ ║
║ │ ⚠️ FAIBLESSES identifiées:       │  │   → Seuls 3 acteurs positionnés │ ║
║ │ • Couverture SAV limitée        │  │                                 │ ║
║ │ • Pas de financement intégré    │  │ 📊 ROI potentiel: 120-180M€     │ ║
║ └─────────────────────────────────┘  └─────────────────────────────────┘ ║
║                                                                          ║
║ ┌─────────────── MATRICES STRATÉGIQUES ─────────────────────────────────┐ ║
║ │                                                                        │ ║
║ │ MATRICE ATTRACTIVITÉ/COMPÉTITIVITÉ par région:                        │ ║
║ │                                                                        │ ║
║ │ Compétitivité ▲                                                       │ ║
║ │ (notre position)                                                       │ ║
║ │    Forte  │     🟢 PACA        🟢 Occitanie                           │ ║
║ │           │     (Leader local)  (Expansion)                           │ ║
║ │           │                                                           │ ║
║ │    Moyenne│  🟡 Auvergne      🟠 Centre-VL                           │ ║
║ │           │  (Potentiel)      (Consolidation)                         │ ║
║ │           │                                                           │ ║
║ │    Faible │ 🔴 Bretagne    🔴 Normandie    🟡 Hauts-de-Fr           │ ║
║ │           │ (Éviter)       (Réfléchir)     (Opportunité)             │ ║
║ │           └─────────────────┼─────────────────┼─────────────────▶     │ ║
║ │                          Faible          Forte          Très forte    │ ║
║ │                                    Attractivité marché                │ ║
║ └────────────────────────────────────────────────────────────────────────┘ ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

# 3. PRINCIPES UX APPLIQUÉS

## 3.1 Parcours Utilisateur Optimisé

### Persona Principal - "Le Directeur Général Pressé"
```
👤 PROFIL:
• Directeur Général PME énergétique (200-2000 salariés)  
• 15 ans d'expérience secteur, formation commerciale/ingénieur
• Objectif: Décisions d'investissement 5-50M€ sur 3-5 ans
• Contrainte: 15-20 min/semaine maximum pour consultation

📱 PARCOURS TYPE (Lundi 8h30):
1. [2 min]  Accueil → Lecture alertes & KPIs critiques
2. [5 min]  Navigation thématique selon priorité semaine  
3. [3 min]  Drill-down sur zone/opportunité identifiée
4. [2 min]  Export insight pour CODIR/équipe commerciale
5. [3 min]  Configuration alertes personnalisées
```

### User Journey Mapping

```
ÉTAPE 1: ORIENTATION (0-30s)
├── Besoin: "Que dois-je savoir cette semaine ?"
├── Action: Scan visuel page accueil
├── Attente: Identification immédiate des priorités  
└── Satisfaction: 🟢 Alertes visibles, KPIs contextualisés

ÉTAPE 2: INVESTIGATION (30s-8min)  
├── Besoin: "Pourquoi cette alerte ? Impact business ?"
├── Action: Navigation sections thématiques
├── Attente: Données contextualisées et comparatives
└── Satisfaction: 🟢 Drill-down intuitif, explications claires

ÉTAPE 3: DÉCISION (8-15min)
├── Besoin: "Quelle action prendre ? Avec qui ?"
├── Action: Analyse détaillée, export de données
├── Attente: Recommandations actionnables
└── Satisfaction: 🟢 Insights stratégiques, données exportables

ÉTAPE 4: SUIVI (15-20min)
├── Besoin: "Comment monitorer cette décision ?"
├── Action: Configuration alertes et bookmarks
├── Attente: Automatisation du suivi  
└── Satisfaction: 🟢 Alertes personnalisées, tableau de bord custom
```

## 3.2 Codes Couleurs et Signalétique

### Palette Couleurs Métier

```css
/* PALETTE PERFORMANCE */
--success-green: #10B981;      /* Objectifs atteints, croissance forte */
--warning-orange: #F59E0B;     /* Attention, surveillance requise */
--danger-red: #EF4444;         /* Alerte, action urgente */
--info-blue: #3B82F6;          /* Information, contexte */

/* PALETTE ÉNERGÉTIQUE */
--solar-gold: #FFD700;         /* Photovoltaïque */  
--wind-cyan: #00BFFF;          /* Éolien */
--nuclear-coral: #FF6347;      /* Nucléaire */
--grid-gray: #6B7280;          /* Réseau, infrastructure */

/* PALETTE GÉOGRAPHIQUE */
--region-leader: #064E3B;      /* Régions dominantes (vert foncé) */
--region-growth: #059669;      /* Régions en croissance (vert) */
--region-develop: #F59E0B;     /* Régions à développer (orange) */
--region-untapped: #DC2626;    /* Régions potentiel inexploité (rouge) */
```

### Iconographie Cohérente

```
📊 Données/Analytics    🎯 Objectifs/Targets     ⚡ Énergie/Production
🗺️ Géographie/Carte     ⏱️ Temps/Évolution      🏢 Concurrence/Business  
🔥 Urgent/Critique      💡 Insight/Recommandation  🚨 Alerte/Attention
🟢 Positif/Bon         🟡 Neutre/Surveillance    🔴 Négatif/Problème
📈 Croissance/Hausse    📉 Décroissance/Baisse   📊 Stable/Neutre
🏆 Leader/Meilleur      ⚠️ Risque/Attention      🎉 Opportunité
```

### Hiérarchie Visuelle

```
NIVEAU 1 - CRITIQUE (attention immédiate):
├── Taille: 24-32px  │ Couleur: Rouge/Orange vif  │ Animation: Clignotant
├── Contour: 3px     │ Fond: Dégradé              │ Icône: 🚨🔥⚠️

NIVEAU 2 - IMPORTANT (attention requise):  
├── Taille: 18-24px  │ Couleur: Orange/Bleu       │ Animation: Pulse
├── Contour: 2px     │ Fond: Coloré 20%           │ Icône: 📊💡🎯

NIVEAU 3 - STANDARD (information):
├── Taille: 14-18px  │ Couleur: Gris foncé        │ Animation: Hover
├── Contour: 1px     │ Fond: Blanc/Gris clair     │ Icône: Monochrome
```

## 3.3 Interactivité et Drill-Down

### Système de Navigation Progressive

```
NIVEAU 0 - VUE D'ENSEMBLE
├── Hover: Preview données détaillées
├── Click: Navigation vers section thématique
└── Context menu: Actions rapides (export, alerte, bookmark)

NIVEAU 1 