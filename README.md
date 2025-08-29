# Atelier LLM pour Data Engineers
## Cas d'usage : Observatoire Photovoltaïque France 🌞

### 🎯 Objectif
Apprendre à utiliser efficacement les Copilot (https://copilot.cloud.microsoft) pour accélérer les projets Data Engineering, de la conception à la livraison client.

### ⏱️ Format
- **Durée :** 4 heures
- **Format :** Atelier hands-on en équipes de 3-4 personnes  
- **Niveau :** Consultant Data avec bases SQL/Snowflake
- **Prérequis :** Accès Copilot Teamwork ou autre LLM personnel + environnement Snowflake Teamwork

---

## 🚀 Déroulement de l'Atelier

### 📋 Phase 1 : Conception (60 minutes)
*Concevoir l'observatoire photovoltaïque avec l'aide d'un LLM*

#### 1.1 Dossier de Conception Technique (20 min)
- **Objectif :** Produire un document de conception de 3-4 pages
- **Rôle :** Data Architect senior
- **Guide :** 👉 [Dossier Technique](./prompts/conception/dossier_technhique.md)

#### 1.2 Catalogue d'Indicateurs Métier (20 min)
- **Objectif :** Créer ~10 indicateurs KPIs documentés
- **Rôle :** Consultant Business/Data Analyst
- **Guide :** 👉 [Catalogue Indicateurs](./prompts/conception/catalogue_indicateurs.md)

#### 1.3 Design du Tableau de Bord (20 min)
- **Objectif :** Architecture du dashboard + wireframes
- **Rôle :** Data Analyst et UX Designer
- **Guide :** 👉 [Design Dashboard](./prompts/conception/design_dashboard.md)

---

### 🔧 Phase 2 : Intégration & Modélisation (90 minutes)
*De la donnée brute aux indicateurs métier avec les LLM*

#### 2.1 Analyse des Sources + Modèle Cible (20 min)
- **Objectif :** Modèle dimensionnel + mapping source-cible
- **Ressources :** 📊 [Données CSV](./data/raw/) à upload via l'interface du LLM
- **Guide :** 👉 [Analyse Sources](./prompts/integration/analyse_sources.md)

#### 2.2 Génération Pipeline Complet (30 min)
- **Objectif :** Scripts SQL Snowflake complets et documentés
- **Livrable :** Code prêt pour déploiement
- **Guide :** 👉 [Pipeline Complet](./prompts/integration/pipeline_complet.md)

#### 2.3 Implémentation et Validation (40 min)
- **Objectif :** Déployer et tester dans Snowflake réel
- **Mission :** Modèle fonctionnel avec vraies données
- **Guide :** 👉 [Implémentation & Validation](./prompts/integration/implementation_validation.md)

---

### ✅ Phase 3 : Plan de Recette - OPTIONNELLE (40 minutes)
*Valider et présenter son travail*

#### 3.1 Stratégie de Test Complète (20 min)
- **Objectif :** Plan de recette structuré et jeux de tests
- **Rôle :** QA Engineer expert projets Data
- **Guide :** 👉 [Stratégie Tests](./prompts/recette/strategie_tests.md)

#### 3.2 Documentation Utilisateur (20 min)
- **Objectif :** Package documentaire complet pour le client
- **Rôle :** Technical Writer spécialisé solutions Data
- **Guide :** 👉 [Documentation Utilisateur](./prompts/recette/documentation_utilisateur.md)

---

### 📊 Phase 4 : Évaluation (20 minutes)
*Capitaliser sur l'expérience et définir un plan d'action*

#### 4.1 Débrief et Évaluation (20 min)
- **Objectif :** Auto-évaluation + plan d'action personnel
- **Format :** Individuel puis partage collectif
- **Guide :** 👉 [Débrief Évaluation](./evaluation/debrief_evaluation.md)

---

## 📁 Organisation des Ressources

### 🤖 Prompts par Phase
```
prompts/
├── conception/           # Phase 1 - Conception
│   ├── dossier_technhique.md
│   ├── catalogue_indicateurs.md
│   └── design_dashboard.md
├── integration/          # Phase 2 - Intégration & Modélisation
│   ├── analyse_sources.md
│   ├── pipeline_complet.md
│   └── implementation_validation.md
└── recette/             # Phase 3 - Plan de Recette (Optionnel)
    ├── strategie_tests.md
    └── documentation_utilisateur.md
```

### 📊 Données d'Entraînement
- **Fichier principal :** [`data/raw/prod-region-annuelle-filiere.csv`](./data/raw/prod-region-annuelle-filiere.csv)
- **Source :** Open Data Réseaux Énergies (ODRÉ)
- **Contenu :** Production électrique annuelle par région et filière (2012-2024)

### 📋 Templates et Évaluation
- **Évaluation :** [`evaluation/`](./evaluation/) - Grilles d'auto-évaluation et débrief

---

## 💡 Conseils pour Réussir l'Atelier

### ✅ Bonnes Pratiques LLM
1. **Définir un rôle précis** : "Agis comme un Data Architect senior..."
2. **Donner du contexte métier** : Secteur photovoltaïque, enjeux business
3. **Structurer les demandes** : Points numérotés, format de sortie spécifié
4. **Itérer et raffiner** : Utiliser les prompts de raffinement fournis

### ⚠️ Points de Vigilance
- **Toujours valider** les outputs techniques générés par l'IA
- **Tester le code SQL** sur de vraies données avant finalisation
- **Garder l'expertise métier** : l'IA génère, l'humain valide et ajuste
- **Documenter les bonnes pratiques** découvertes pour réutilisation

---

## 🎉 Objectifs de Fin d'Atelier

À l'issue des 4 heures, vous aurez :

### 📈 Compétences LLM Acquises
- [ ] Maîtrise du prompting complexe avec contexte et rôle
- [ ] Techniques d'itération et raffinement des réponses
- [ ] Identification des limites des LLM sur les aspects techniques
- [ ] Capacité à générer des livrables clients de qualité avec l'IA

### 🛠️ Compétences Techniques Renforcées
- [ ] Conception d'architecture Data end-to-end
- [ ] Modélisation dimensionnelle adaptée aux besoins métier
- [ ] Développement SQL Snowflake avec optimisations
- [ ] Stratégie de tests et validation de solutions Data

### 🎯 Livrables Concrets
- Un observatoire photovoltaïque opérationnel dans Snowflake
- Une méthodologie reproductible d'usage des LLM
- Une bibliothèque de prompts réutilisables
- Un plan d'action personnel pour vos projets futurs

---

## 🤝 Support et Contribution

### 📞 Besoin d'Aide ?
- **Pendant l'atelier :** Lever la main, les animateurs circulent
- **Problèmes techniques :** Focus sur l'apprentissage, pas la perfection
- **Questions métier :** S'appuyer sur les connaissances collectives du groupe dans le domaine métier

---

**🚀 Prêt à transformer votre pratique du Data Engineering avec l'IA ? C'est parti !**

*Atelier conçu par l'équipe Practice Data - Version 1.0*
