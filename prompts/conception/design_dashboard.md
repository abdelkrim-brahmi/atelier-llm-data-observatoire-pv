# Prompt : Design du Tableau de Bord

## 🎯 Contexte d'Usage
Concevoir l'architecture UX/UI d'un tableau de bord exécutif pour des décideurs non-techniques du secteur énergétique.

## 📋 Objectif
Créer l'architecture complète du dashboard avec wireframes, navigation et recommandations techniques adaptées aux dirigeants.

## ⏱️ Temps Alloué
20 minutes

## 👤 Rôle à Adopter
Data Analyst et UX Designer spécialisé en data visualization

## 📊 Livrable Attendu
Architecture du dashboard + wireframes des pages principales

## 🤖 Prompt Principal

```
Agis comme un UX Designer expert en data visualization avec une spécialisation dans les dashboards exécutifs pour le secteur énergétique.

CONTEXTE : Je dois concevoir l'interface de l'observatoire photovoltaïque français pour des dirigeants d'entreprises énergétiques qui ont besoin de prendre des décisions stratégiques rapides.

CONTRAINTES UTILISATEUR :
- Profil : Dirigeants et managers (non-techniques)
- Usage : Consultation hebdomadaire de 15-20 minutes  
- Objectif : Identifier opportunités et risques de marché
- Support : PC/tablette, consultation en mobilité occasionnelle

MISSION : Conçois l'architecture complète du dashboard

1. STRUCTURE GÉNÉRALE
   - Organisation des pages/onglets par thématique
   - Navigation intuitive entre les vues
   - Hiérarchie de l'information (synthèse → détail)

2. WIREFRAMES DES PAGES CLÉS
   - Page d'accueil avec KPIs essentiels
   - Vue géographique (cartes interactives)
   - Analyse temporelle (évolutions et tendances)
   - Comparatifs et benchmarks sectoriels

3. PRINCIPES UX APPLIQUÉS
   - Parcours utilisateur optimisé
   - Codes couleurs et signalétique
   - Interactivité et drill-down

4. RECOMMANDATIONS TECHNIQUES
   - Outil de restitution recommandé (Power BI, Tableau, Qlik)
   - Architecture technique (temps réel vs batch)
   - Gestion des droits et sécurité

Utilise du texte ASCII pour les wireframes si nécessaire.
```

## 🔧 Prompts de Raffinement

### Pour Approfondir l'Expérience Utilisateur
```
Enrichis la conception UX en détaillant :
- User journey mapping depuis la connexion jusqu'à la prise de décision
- Personas détaillés : CEO, Directeur Développement, Directeur Stratégie
- Scénarios d'usage mobile vs desktop avec adaptations spécifiques
- Gestion des notifications et alertes intelligentes
- Personnalisation du dashboard selon le profil utilisateur
```

### Pour Optimiser les Performances
```
Ajoute des recommandations de performance :
- Stratégie de chargement progressif des données
- Mise en cache intelligente des visualisations coûteuses
- Optimisation pour les connexions lentes (mode dégradé)
- Pré-calculs et vues matérialisées pour les KPIs temps réel
- Gestion de la charge avec nombreux utilisateurs simultanés
```

### Pour Intégrer l'Intelligence Artificielle
```
Propose des fonctionnalités IA intégrées au dashboard :
- Insights automatiques et détection d'anomalies
- Recommandations contextuelles selon le profil utilisateur
- Chatbot intégré pour poser des questions en langage naturel
- Alertes prédictives sur les tendances de marché
- Génération automatique de rapports narratifs
```

## ✅ Critères de Validation

- [ ] Architecture logique adaptée aux cas d'usage dirigeants
- [ ] Wireframes des 4 pages principales esquissés
- [ ] Choix technique justifié (Power BI vs Tableau vs autres)
- [ ] Principes UX adaptés à l'audience non-technique
- [ ] Navigation intuitive et hiérarchie de l'information claire
- [ ] Recommandations techniques cohérentes avec les contraintes

## 💡 Point d'Attention

N'hésitez pas à demander des wireframes en mode texte ASCII - ChatGPT est très efficace pour créer des représentations visuelles simples mais parlantes.

## 📐 Exemple de Wireframe ASCII

```
┌─────────────────────────────────────────────────┐
│ OBSERVATOIRE PHOTOVOLTAÏQUE FRANCE         [⚙️] │
├─────────────────────────────────────────────────┤
│ [📊 Vue d'ensemble] [🗺️ Territorial] [📈 Évolution] │
├─────────────────────────────────────────────────┤
│                                                 │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ │
│ │   15.2 GW   │ │   +12.3%    │ │   3.2€/MWh  │ │
│ │ Total installé│ │ Croissance  │ │    LCOE     │ │
│ └─────────────┘ └─────────────┘ └─────────────┘ │
│                                                 │
│ ┌─────────────────────────────────────────────┐ │
│ │           PRODUCTION PAR RÉGION             │ │
│ │  [Carte de France interactive]              │ │
│ │                                             │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ ┌───────────────────┐ ┌───────────────────────┐ │
│ │ TOP 5 RÉGIONS     │ │ ALERTES & TENDANCES   │ │
│ │ 1. PACA    2.1GW  │ │ 🔴 Ralentissement     │ │
│ │ 2. Occitanie 1.8  │ │    Île-de-France      │ │
│ │ 3. Nouvelle Aquit │ │ 🟢 Opportunité forte  │ │
│ └───────────────────┘ │    Grand Est          │ │
│                       └───────────────────────┘ │
└─────────────────────────────────────────────────┘
```

## 🎨 Guidelines de Design

### Palette de Couleurs Recommandée
- **Primaire :** Bleu énergétique (#0066CC) pour données positives
- **Secondaire :** Orange solaire (#FF9900) pour alertes et focus
- **Tertiaire :** Vert croissance (#00AA44) pour indicateurs positifs
- **Neutre :** Gris (#666666) pour données contextuelles
- **Alerte :** Rouge (#CC0000) pour risques et anomalies

### Typographie
- **Titres :** Police sans-serif, bold, taille 18-24px
- **Métriques :** Police mono-space pour alignement des chiffres
- **Labels :** Police standard, taille 12-14px, contraste élevé

## 📱 Responsive Design

### Adaptation Mobile/Tablette
```
┌─────────────────────┐
│  ☰ OBSERVATOIRE PV  │
├─────────────────────┤
│                     │
│ ┌─────────────────┐ │
│ │    15.2 GW      │ │
│ │ Total installé  │ │
│ └─────────────────┘ │
│                     │
│ ┌─────────────────┐ │
│ │     +12.3%      │ │
│ │   Croissance    │ │
│ └─────────────────┘ │
│                     │
│ ┌─────────────────┐ │
│ │   [Carte Mini]  │ │
│ │   Tap to zoom   │ │
│ └─────────────────┘ │
│                     │
│ [ Voir détails > ]  │
└─────────────────────┘
```

## 🔄 Interactions Clés

1. **Click sur KPI** → Drill-down vers détail régional
2. **Hover sur carte** → Tooltip avec métriques locales  
3. **Sélection période** → Mise à jour temps réel de tous les graphiques
4. **Export** → Génération PDF executive summary
5. **Partage** → Lien sécurisé vers vue spécifique

## 📊 Templates de Visualisations

### KPIs Numériques
- **Valeur principale** en grande taille
- **Évolution** avec flèche et pourcentage coloré
- **Contexte** avec benchmark ou objectif
- **Trend** avec sparkline sur 12 mois

### Graphiques Temporels
- **Line charts** pour évolutions continues
- **Bar charts** pour comparaisons périodiques
- **Area charts** pour cumuls et compositions
- **Dual axis** pour corréler métriques différentes

### Visualisations Géographiques
- **Choropleth maps** pour densités régionales
- **Bubble maps** pour volumes absolus
- **Heat maps** pour analyses de performance
- **Flow maps** pour échanges inter-régionaux

Cette structure de prompt garantit un design professionnel adapté aux besoins des dirigeants tout en restant techniquement réalisable.
