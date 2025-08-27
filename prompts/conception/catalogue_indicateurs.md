# Prompt : Catalogue d'Indicateurs Métier

## 🎯 Contexte d'Usage
Générer un catalogue exhaustif d'indicateurs KPIs pour un observatoire sectoriel.

## 📋 Objectif
Créer un catalogue de 15-20 indicateurs documentés, organisés par thématique et priorisés selon l'impact business.

## 🤖 Prompt Principal

```
Agis comme un expert Data Analyst spécialisé dans les énergies renouvelables avec une connaissance approfondie du marché français du photovoltaïque et des besoins des entreprises du secteur.

CONTEXTE : Je crée un observatoire stratégique du photovoltaïque en France destiné aux entreprises qui souhaitent développer leur activité : installateurs, développeurs de projets, investisseurs, fabricants, collectivités territoriales.

MISSION : Crée un catalogue exhaustif d'indicateurs KPIs organisé par thématiques métier business.

STRUCTURE DEMANDÉE pour chaque indicateur :
- Nom de l'indicateur (clair et business-friendly)
- Définition métier en 1-2 phrases (pourquoi c'est important)
- Formule de calcul précise et exploitable techniquement
- Granularité disponible (nationale/régionale/départementale/communale)
- Fréquence de mise à jour réaliste (temps réel/quotidien/mensuel/trimestriel)
- Source de données recommandée (RTE, Enedis, ODRÉ, etc.)
- Cas d'usage business concrets (3-4 exemples d'utilisation)
- Niveau de priorité avec justification (P0=critique, P1=important, P2=nice-to-have)
- Seuils d'alerte suggérés (quand s'inquiéter ?)

THÉMATIQUES OBLIGATOIRES À COUVRIR :
1. **CAPACITÉ & INSTALLATIONS** (puissance, nombre sites, segmentation marché)
2. **PRODUCTION & PERFORMANCE** (électricité produite, facteurs charge, rendement)
3. **ÉCONOMIE & MARCHÉ** (investissements, LCOE, rentabilité, tarifs)
4. **TERRITOIRE & GÉOGRAPHIE** (densité, répartition régionale, potentiel)
5. **RÉGLEMENTATION & POLITIQUE** (soutien public, quotas, appels d'offres)

CONTRAINTES :
- Au moins 3 indicateurs P0 par thématique
- Formules de calcul réellement implémentables en SQL
- Sources de données vérifiées et accessibles en France
- Benchmarks sectoriels quand pertinents

Présente sous forme de tableau structurées avec une synthèse executive en introduction du tableau.
```

## 🔧 Prompts de Spécialisation

### Focus sur les Indicateurs Avancés
```
Pour les indicateurs P0, enrichis avec :
- Corrélations statistiques avec d'autres métriques du catalogue
- Algorithmes de détection d'anomalies (seuils dynamiques)
- Métriques de qualité des données sources
- Historique de volatilité et saisonnalité
- Benchmarks européens pour contextualiser les valeurs françaises
```

### Adaptation par Segment de Marché
```
Décline ce catalogue selon 3 segments clients distincts :
1. **SEGMENT INSTALLATEURS** : Focus rentabilité projets, pipeline commercial
2. **SEGMENT INVESTISSEURS** : Focus ROI, risques, performance de portefeuille
3. **SEGMENT COLLECTIVITÉS** : Focus transition énergétique, aménagement territorial

Pour chaque segment, adapte la formulation et priorise différemment les KPIs.
```

### Indicateurs Prédictifs
```
Ajoute une section "INDICATEURS PRÉDICTIFS" avec :
- Métriques de tendance et signaux faibles
- Indicateurs avancés de saturation de marché
- Scores de potentiel de développement territorial
- Alertes précoces sur évolutions réglementaires
- Indices de compétitivité régionale
```

## ✅ Critères de Validation

- [ ] 15-20 indicateurs minimum répartis sur les 5 thématiques
- [ ] Formules de calcul techniquement exploitables
- [ ] Priorisation P0/P1/P2 cohérente et justifiée
- [ ] Sources de données réalistes et accessibles
- [ ] Cas d'usage business concrets et différenciés
- [ ] Seuils d'alerte pertinents pour la prise de décision

## 📊 Template de Fiche Indicateur

```markdown
### 📈 [NOM INDICATEUR]

**Priorité :** P0 | **Thématique :** Capacité & Installations

**Définition :** 
[Explication business de l'indicateur en 2 phrases max]

**Formule :**
```sql
-- Exemple de calcul SQL
SELECT region, SUM(puissance_mw) as total_capacity
FROM installations_pv 
WHERE date_raccordement >= '2024-01-01'
GROUP BY region
```

**Granularité :** Régionale, Départementale  
**Fréquence :** Mensuelle  
**Source :** RTE - Registre national des installations

**Cas d'Usage :**
- Identification des régions à forte croissance
- Benchmark concurrentiel par territoire  
- Planification de stratégie commerciale
- Aide à la décision d'implantation

**Seuils d'Alerte :**
- 🔴 Croissance < 5% annuelle (marché en difficulté)
- 🟠 Croissance 5-15% (surveillance marché)
- 🟢 Croissance > 15% (opportunité forte)

**Corrélations :**
- Forte corrélation avec investissements régionaux (+0.8)
- Anticipe la production future (décalage 6 mois)
```

## 💡 Conseils d'Usage

- **Commencer simple** puis enrichir avec les prompts de spécialisation
- **Valider les formules** sur de vraies données avant finalisation
- **Tester la pertinence métier** avec des experts du secteur
- **Adapter le vocabulaire** selon l'audience (technique vs business)

## 📋 Checklist de Livrable Final

- [ ] Synthèse exécutive (top 5 des KPIs incontournables)
- [ ] 5 thématiques couvertes avec 3-4 indicateurs chacune
- [ ] Matrice de priorisation et interdépendances
- [ ] Guide d'interprétation des seuils d'alerte
- [ ] Roadmap d'implémentation par phases (quick wins d'abord)
