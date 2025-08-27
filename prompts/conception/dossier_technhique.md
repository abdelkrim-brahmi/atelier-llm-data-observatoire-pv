# Prompt : Dossier de Conception Technique

## 🎯 Contexte d'Usage
Utiliser pour générer un dossier de conception complet lors de la phase d'initialisation d'un projet Data.

## 📋 Objectif
Produire un document de conception technique de 3-4 pages structuré et professionnel, prêt pour présentation client.

## 🤖 Prompt Principal

```
Agis comme un Data Architect senior avec 10 ans d'expérience en projets énergétiques.

CONTEXTE : Je dois concevoir un observatoire du photovoltaïque en France pour une entreprise énergétique qui veut développer son activité dans ce secteur de manière stratégique. Cet observatoire servira à analyser les tendances de marché, identifier les opportunités territoriales et benchmarker la concurrence.

MISSION : Produis-moi un dossier de conception technique structuré incluant :

1. VISION & OBJECTIFS
   - Enjeux business de l'observatoire
   - Utilisateurs cibles et cas d'usage prioritaires
   - KPIs de succès du projet (3-5 indicateurs mesurables)

2. ARCHITECTURE FONCTIONNELLE  
   - Schéma des flux de données (source → traitement → restitution)
   - Briques techniques recommandées (Cloud, outils ETL, viz)
   - Contraintes et exigences non-fonctionnelles (performance, sécurité)

3. MODÈLE DE DONNÉES CONCEPTUEL
   - Entités principales et relations clés
   - Granularité temporelle et géographique optimale
   - Règles de gestion métier critiques

4. PLANNING MACRO & GOUVERNANCE
   - Phases du projet avec jalons et livrables
   - Estimation des charges par lot (conception, dev, recette)
   - Risques techniques et métier identifiés avec mitigation
   - Organisation projet et parties prenantes

Format de sortie : Document structuré avec titres H1/H2, prêt pour un client exigeant.
Ton professionnel mais accessible, avec des exemples concrets du secteur photovoltaïque français.
```

## 🔧 Prompts de Raffinement

### Pour Personnaliser le Contexte Client
```
Le document est bien mais trop générique. Personnalise-le davantage pour notre contexte :
- Client : [TYPE D'ENTREPRISE] qui opère dans [RÉGIONS/ACTIVITÉS]
- Budget projet estimé : [MONTANT] sur [DURÉE]
- Contraintes spécifiques : [CONTRAINTES TECHNIQUES/ORGANISATIONNELLES]
- Ajoute des références aux réglementations françaises du secteur énergétique
```

### Pour Approfondir l'Architecture Technique
```
Détaille davantage la section architecture technique :
- Précise les technologies Cloud recommandées (AWS/Azure/GCP)
- Justifie le choix des outils ETL pour les données énergétiques
- Ajoute un schéma d'architecture en mode texte ASCII
- Inclus les considérations de sécurité et RGPD
```

### Pour Enrichir le Planning
```
Affine le planning projet en ajoutant :
- Estimation détaillée des charges par profil (Data Engineer, Analyst, etc.)
- Dépendances critiques avec les sources de données externes
- Plan de montée en charge et phases de déploiement
- Stratégie de formation des utilisateurs finaux
```

## ✅ Critères de Validation

- [ ] Document fait 3-4 pages minimum avec structure claire
- [ ] Architecture technique cohérente avec les enjeux business
- [ ] Planning réaliste avec estimations justifiées
- [ ] Identification proactive des risques et solutions
- [ ] Vocabulaire technique approprié mais accessible
- [ ] Références spécifiques au secteur photovoltaïque français

## 💡 Conseils d'Usage

- **Itérer progressivement** : Commencer par le prompt principal, puis raffiner section par section
- **Adapter le vocabulaire** selon l'audience (technique vs management)
- **Sauvegarder les bonnes variantes** pour les projets futurs
- **Valider la cohérence** entre architecture et planning

## 📝 Exemple de Résultat Attendu

Le prompt doit générer un document avec cette structure :

```
# DOSSIER DE CONCEPTION - OBSERVATOIRE PHOTOVOLTAÏQUE

## 1. VISION & OBJECTIFS
### Enjeux Business
- Positionnement stratégique sur le marché PV français
- [...]

### Cas d'Usage Prioritaires  
- Identification d'opportunités de développement territorial
- [...]

## 2. ARCHITECTURE FONCTIONNELLE
### Flux de Données
[Schéma textuel des flux]
### Stack Technique
- Ingestion : Snowflake + APIs publiques
- [...]

[etc.]
```
