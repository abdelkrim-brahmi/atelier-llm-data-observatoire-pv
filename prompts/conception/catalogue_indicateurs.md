# Activité 1.2 : Catalogue d'Indicateurs Métier

## 🎯 Contexte d'Usage
Générer un catalogue d'indicateurs KPIs business pour un observatoire photovoltaïque destiné aux entreprises du secteur.

## ⏱️ Temps Alloué
20 minutes

## 👤 Votre Rôle
Consultant Business/Data Analyst spécialisé énergies renouvelables

## 📊 Livrable Attendu
Catalogue d'environ 10 indicateurs documentés et priorisés

## 🤖 Prompt à Copier-Coller

```
Agis comme un expert Data Analyst spécialisé dans les énergies renouvelables avec une connaissance approfondie du marché français du photovoltaïque.

CONTEXTE : Je crée un observatoire stratégique du photovoltaïque en France destiné aux entreprises qui souhaitent développer leur activité (installateurs, développeurs de projets, investisseurs, fabricants).

MISSION : Crée un catalogue exhaustif d'indicateurs KPIs organisé par thématiques métier.

STRUCTURE DEMANDÉE pour chaque indicateur :
- Nom de l'indicateur
- Définition business en 1-2 phrases
- Formule de calcul précise
- Granularité (nationale/régionale/départementale)
- Fréquence de mise à jour (temps réel/mensuelle/trimestrielle)
- Source de données recommandée
- Intérêt stratégique (pourquoi cet indicateur aide à la décision)
- Niveau de priorité (P0=essentiel, P1=important, P2=nice-to-have)

THÉMATIQUES À COUVRIR :
1. Capacité et installations (puissance, nombre de sites, segmentation)
2. Production et performance (électricité produite, facteurs de charge)
3. Territoire et géographie (densité, répartition régionale)

Présente sous forme de tableau structurées.
```

## ✅ Critères de Validation

- [ ] ~10 indicateurs minimum répartis sur les 3 thématiques
- [ ] Formules de calcul exploitables techniquement
- [ ] Priorisation P0/P1/P2 cohérente avec les enjeux business
- [ ] Sources de données identifiées et réalistes

## 🔧 Prompt Complémentaire pour Affiner

```
Pour les indicateurs P0, ajoute :
- Un exemple de valeur numérique réaliste pour 2024
- Les seuils d'alerte qui nécessiteraient une attention particulière
- Les corrélations avec d'autres indicateurs du catalogue
```

## 💡 Conseils d'Usage

### Optimiser le Prompt Principal
- **Préciser le segment client** si vous ciblez spécifiquement (ex: "focus investisseurs institutionnels")
- **Ajouter le contexte temporel** : "avec vision sur les 3 prochaines années"
- **Spécifier les contraintes** : "indicateurs calculables avec les données publiques françaises"

### Bonnes Pratiques de Formulation
```
Version améliorée du prompt :
"Pour chaque indicateur, assure-toi que :
- La formule soit implémentable en SQL standard
- La source de données soit accessible publiquement
- L'intérêt business soit spécifique au photovoltaïque (pas générique énergie)
- La priorité soit justifiée par l'impact sur la décision d'investissement"
```

## 📋 Template de Fiche Indicateur

```markdown
### 📊 [NOM DE L'INDICATEUR]

**Priorité :** P0 | **Thématique :** Capacité & Installations

**Définition Business :**
[Explication en 1-2 phrases de ce que mesure l'indicateur et pourquoi c'est important]

**Formule de Calcul :**
```sql
SELECT 
    region,
    SUM(puissance_installee_mw) as total_capacity_mw
FROM installations_pv 
WHERE date_raccordement BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY region
```

**Caractéristiques :**
- **Granularité :** Régionale, Départementale
- **Fréquence :** Mensuelle
- **Source :** RTE - Registre national des installations

**Intérêt Stratégique :**
- Identifier les marchés régionaux en croissance
- Benchmark de la concurrence par territoire
- Planification des investissements géographiques

**Valeur 2024 :** 15,200 MW (France métropolitaine)
**Seuils d'Alerte :** 
- 🔴 Décroissance > 5% (marché en difficulté)
- 🟢 Croissance > 20% (opportunité forte)

**Corrélations :**
- Production régionale (+0.85)
- Densité démographique (+0.62)

## 🎯 Variantes de Prompts par Segment

### Pour les Installateurs
```
Adapte le catalogue pour des entreprises d'installation PV qui cherchent :
- Indicateurs de saturation de marché local
- Métriques de concurrence et parts de marché
- Signaux d'opportunités commerciales territoriales
- KPIs de rentabilité par type d'installation
```

### Pour les Investisseurs
```
Oriente le catalogue vers des métriques d'investissement :
- Indicateurs de performance financière (LCOE, ROI)
- Métriques de risque et de volatilité
- Comparatifs de rentabilité par région/technologie
- Signaux de maturité de marché
```

### Pour les Collectivités
```
Personnalise pour les enjeux de politique publique :
- Indicateurs de transition énergétique territoriale
- Métriques d'atteinte des objectifs SNBC/SRADDET
- KPIs d'autonomie énergétique locale
- Mesures d'impact environnemental et social
```

## 🔄 Processus d'Itération

1. **Premier jet** : Utiliser le prompt principal pour obtenir la structure de base
2. **Validation métier** : Vérifier la pertinence business avec le prompt de raffinement
3. **Validation technique** : Contrôler la faisabilité des formules de calcul
4. **Priorisation finale** : Ajuster les niveaux P0/P1/P2 selon le contexte client

## 📊 Exemple de Résultat Structuré

| Indicateur | Thématique | Priorité | Formule | Source | Impact Business |
|------------|------------|----------|---------|---------|-----------------|
| Puissance Installée Cumulée | Capacité | P0 | SUM(puissance_mw) | RTE | Taille de marché |
| Facteur de Charge Moyen | Performance | P0 | Production/Capacité théorique | ODRE | Rentabilité |
| Densité PV Régionale | Territoire | P1 | MW/km² par région | Calcul | Saturation |
| Croissance Trimestrielle | Capacité | P1 | Evolution n vs n-1 | RTE | Dynamique |


## 📋 Résultat Attendu

Afin de nous aligner sur les étapes suivantes :
- **Exemple de catalogue d'indicateurs** :  [catalogue_kpis_photovoltaique](../../sample%20results/catalogue_kpis_resultat.md)


## ⚠️ Pièges à Éviter

- **Indicateurs trop génériques** : Éviter les métriques valables pour toutes les énergies
- **Formules impossibles** : Vérifier que les données sources permettent le calcul
- **Priorisation incohérente** : Aligner P0/P1/P2 avec les vrais enjeux business
- **Sources inaccessibles** : S'assurer que les données sont publiques ou achetables

## 🎉 Critères de Succès

Un bon catalogue d'indicateurs doit permettre à un dirigeant d'entreprise de :
1. **Comprendre le marché** (taille, dynamique, concurrence)
2. **Identifier les opportunités** (territoires, segments, timing)
3. **Mesurer la performance** (vs concurrence, vs objectifs)
4. **Anticiper les risques** (saturation, réglementaire, technique)

Cette structure garantit un livrable professionnel en 20 minutes avec une approche méthodique et réutilisable ! 
