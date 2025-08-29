# Catalogue des KPIs - Observatoire Photovoltaïque France

## Introduction

Ce catalogue présente 45 indicateurs clés de performance (KPIs) structurés en 3 thématiques principales pour l'observatoire stratégique du photovoltaïque français. Chaque KPI est défini avec sa formule de calcul, ses sources de données et son intérêt stratégique pour accompagner les décisions business des acteurs du secteur.

---

# 1. CAPACITÉ ET INSTALLATIONS

Cette thématique couvre les indicateurs liés au parc installé, à sa croissance et à sa segmentation par typologie d'installations.

| **Indicateur** | **Définition Business** | **Formule de Calcul** | **Granularité** | **Fréquence** | **Source Recommandée** | **Intérêt Stratégique** | **Priorité** |
|---|---|---|---|---|---|---|---|
| **Puissance totale installée** | Capacité cumulée de toutes les installations PV raccordées au réseau en France | Σ(Puissance raccordée) par installation active | Nationale/Régionale/Départementale | Mensuelle | ENEDIS/RTE Open Data | Vision globale du marché et benchmarking européen. Base pour tous les ratios de pénétration | **P0** |
| **Nombre total d'installations** | Comptage du nombre de sites photovoltaïques raccordés et actifs | COUNT(installations) WHERE statut = 'active' | Nationale/Régionale/Départementale | Mensuelle | ENEDIS/RTE Open Data | Mesure de la démocratisation du PV et identification des zones de développement | **P0** |
| **Croissance mensuelle de la puissance** | Évolution mensuelle de la capacité installée pour mesurer la dynamique du marché | (Puissance mois N - Puissance mois N-1) / Puissance mois N-1 × 100 | Nationale/Régionale | Mensuelle | ENEDIS/RTE + calcul | Anticipation des tendances et cycles d'investissement. Indicateur de santé du marché | **P0** |
| **Croissance mensuelle des installations** | Nombre de nouvelles installations raccordées mensuellement | COUNT(nouvelles installations mois N) | Nationale/Régionale/Départementale | Mensuelle | ENEDIS/RTE + calcul | Mesure de l'activité commerciale et de l'adoption par les particuliers/entreprises | **P0** |
| **Puissance moyenne par installation** | Taille moyenne des installations pour identifier les tendances technologiques | Puissance totale / Nombre total d'installations | Nationale/Régionale | Mensuelle | ENEDIS/RTE + calcul | Évolution vers des installations plus importantes, stratégies de dimensionnement | **P1** |
| **Répartition résidentiel (<9kWc)** | Part du résidentiel dans le parc installé en puissance | Puissance installations ≤9kWc / Puissance totale × 100 | Nationale/Régionale | Mensuelle | ENEDIS Open Data | Ciblage commercial et stratégies d'offres dédiées aux particuliers | **P0** |
| **Répartition tertiaire (9-100kWc)** | Part du segment tertiaire/industriel en puissance | Puissance installations 9-100kWc / Puissance totale × 100 | Nationale/Régionale | Mensuelle | ENEDIS Open Data | Opportunités B2B et développement commercial entreprises | **P0** |
| **Répartition centrales au sol (>100kWc)** | Part des grandes installations centralisées | Puissance installations >100kWc / Puissance totale × 100 | Nationale/Régionale | Mensuelle | RTE + ENEDIS | Attractivité pour les investisseurs et développeurs de parcs | **P0** |
| **Nombre d'installations résidentielles** | Volume d'installations individuelles chez les particuliers | COUNT(installations) WHERE puissance ≤9kWc | Nationale/Régionale/Départementale | Mensuelle | ENEDIS Open Data | Taille du marché résidentiel et potentiel de développement B2C | **P1** |
| **Nombre d'installations tertiaires** | Volume d'installations sur bâtiments d'entreprises | COUNT(installations) WHERE puissance 9-100kWc | Nationale/Régionale/Départementale | Mensuelle | ENEDIS Open Data | Marché B2B et ciblage des prospects entreprises | **P1** |
| **Nombre de centrales au sol** | Volume de grandes installations de production | COUNT(installations) WHERE puissance >100kWc | Nationale/Régionale/Départementale | Mensuelle | RTE + ENEDIS | Opportunités pour développeurs et investisseurs institutionnels | **P1** |
| **Part des toitures industrielles** | Pourcentage d'installations sur bâtiments industriels | Installations sur toitures industrielles / Total installations × 100 | Régionale | Trimestrielle | Enquêtes sectorielles + ENEDIS | Potentiel inexploité du secteur industriel | **P2** |
| **Taux de renouvellement** | Pourcentage d'installations remplacées annuellement | Installations décommissionnées / Parc total × 100 | Nationale | Annuelle | ENEDIS + enquêtes | Marché de seconde génération et services de maintenance | **P2** |
| **Densité d'installations par km²** | Nombre d'installations par unité de surface | Nombre installations / Surface territoire (km²) | Départementale/Communale | Mensuelle | ENEDIS + INSEE | Saturation territoriale et identification de zones sous-équipées | **P1** |
| **Taille médiane des installations** | Valeur médiane de la puissance installée | MEDIAN(puissance_installation) | Nationale/Régionale | Mensuelle | ENEDIS/RTE + calcul | Tendances de dimensionnement et stratégies tarifaires | **P2** |

---

# 2. PRODUCTION ET PERFORMANCE

Cette thématique analyse la performance énergétique du parc photovoltaïque et son optimisation.

| **Indicateur** | **Définition Business** | **Formule de Calcul** | **Granularité** | **Fréquence** | **Source Recommandée** | **Intérêt Stratégique** | **Priorité** |
|---|---|---|---|---|---|---|---|
| **Production totale annuelle** | Électricité photovoltaïque injectée sur le réseau français | Σ(Production mensuelle) sur 12 mois glissants | Nationale/Régionale | Mensuelle | RTE/ENEDIS + calcul | Part du PV dans le mix énergétique. Contribution aux objectifs climat | **P0** |
| **Facteur de charge moyen** | Ratio entre production réelle et production théorique maximale | (Production réelle / Puissance × 8760h) × 100 | Nationale/Régionale | Mensuelle | RTE + ENEDIS + calcul | Performance du parc et optimisation des installations | **P0** |
| **Productivité spécifique moyenne** | Production annuelle rapportée à la puissance installée | Production annuelle (kWh) / Puissance installée (kWc) | Nationale/Régionale | Mensuelle | RTE/ENEDIS + calcul | Benchmark performance et choix technologiques | **P0** |
| **Production mensuelle** | Électricité produite sur la période courante | Σ(Production installation i) mois N | Nationale/Régionale | Mensuelle | RTE/ENEDIS | Saisonnalité et prévisions de production | **P1** |
| **Évolution production vs année N-1** | Croissance de la production par rapport à l'année précédente | (Production année N - Production année N-1) / Production année N-1 × 100 | Nationale/Régionale | Mensuelle | RTE/ENEDIS + calcul | Dynamique de croissance et impact des nouvelles installations | **P1** |
| **Facteur de charge par segment** | Performance par typologie d'installation (résidentiel, tertiaire, sol) | Production segment / (Puissance segment × 8760h) × 100 | Nationale/Régionale | Mensuelle | ENEDIS/RTE + segmentation | Optimisation par segment et conseil technique | **P1** |
| **Taux de disponibilité** | Pourcentage d'installations en fonctionnement normal | Installations actives / Total installations × 100 | Nationale/Régionale | Mensuelle | ENEDIS + monitoring | Qualité du parc et besoins de maintenance | **P1** |
| **Performance vs irradiation théorique** | Ratio production réelle vs potentiel solaire théorique | Production réelle / (Irradiation × Puissance × PR théorique) × 100 | Régionale | Mensuelle | Météo-France + RTE + calcul | Identification des sous-performances et actions correctives | **P1** |
| **Production par kWc résidentiel** | Productivité spécifique du segment résidentiel | Production résidentiel / Puissance résidentielle | Régionale | Mensuelle | ENEDIS + calcul | Performance des installations particuliers et conseil | **P2** |
| **Production par kWc tertiaire** | Productivité spécifique du segment tertiaire | Production tertiaire / Puissance tertiaire | Régionale | Mensuelle | ENEDIS + calcul | Performance B2B et optimisation installations entreprises | **P2** |
| **Production par kWc centrales sol** | Productivité spécifique des grandes centrales | Production centrales sol / Puissance centrales sol | Régionale | Mensuelle | RTE + calcul | Performance des investissements centrales et choix sites | **P2** |
| **Variabilité saisonnière** | Écart-type de la production mensuelle normalisée | STDEV(Production mensuelle / Puissance) × 12 mois | Nationale/Régionale | Trimestrielle | RTE/ENEDIS + calcul | Impact saisonnalité sur revenus et dimensionnement stockage | **P2** |
| **Heures équivalentes moyennes** | Nombre d'heures théoriques à puissance nominale | Production annuelle / Puissance installée | Régionale | Annuelle | RTE/ENEDIS + calcul | Benchmark régional et aide au dimensionnement | **P1** |
| **Part production autoconsommée** | Pourcentage de l'électricité consommée sur site | Production autoconsommée / Production totale × 100 | Nationale | Trimestrielle | Enquêtes + ENEDIS | Évolution modèles économiques et impact sur réseau | **P2** |
| **Taux de couverture électrique PV** | Part du PV dans la consommation électrique française | Production PV / Consommation électrique totale × 100 | Nationale | Mensuelle | RTE + calcul | Contribution énergétique et objectifs transition | **P0** |

---

# 3. TERRITOIRE ET GÉOGRAPHIE

Cette thématique analyse la répartition spatiale du photovoltaïque et le potentiel de développement territorial.

| **Indicateur** | **Définition Business** | **Formule de Calcul** | **Granularité** | **Fréquence** | **Source Recommandée** | **Intérêt Stratégique** | **Priorité** |
|---|---|---|---|---|---|---|---|
| **Puissance par habitant** | Densité d'équipement PV rapportée à la population | Puissance installée (W) / Population territoire | Régionale/Départementale | Mensuelle | ENEDIS/RTE + INSEE | Potentiel résiduel et ciblage territorial | **P0** |
| **Puissance par km²** | Densité géographique des installations photovoltaïques | Puissance installée (kW) / Surface territoire (km²) | Départementale/Communale | Mensuelle | ENEDIS/RTE + IGN | Saturation territoriale et identification zones développement | **P0** |
| **Taux de pénétration résidentiel** | Part des logements équipés en photovoltaïque | Installations résidentielles / Nombre logements × 100 | Départementale/Communale | Trimestrielle | ENEDIS + INSEE | Potentiel de développement B2C par territoire | **P0** |
| **Concentration géographique** | Indice de Herfindahl de répartition par département | Σ(Part département i)² | Nationale | Trimestrielle | ENEDIS/RTE + calcul | Diversification géographique et risques concentration | **P1** |
| **Croissance relative par région** | Évolution comparée entre régions sur 12 mois | Croissance région / Croissance nationale - 1 | Régionale | Mensuelle | ENEDIS/RTE + calcul | Dynamiques territoriales et repositionnement commercial | **P0** |
| **Potentiel résiduel par département** | Capacité de développement estimée restante | Potentiel théorique - Puissance installée | Départementale | Trimestrielle | ADEME + ENEDIS + calcul | Priorisation investissements et expansion territoriale | **P0** |
| **Rang départemental puissance** | Classement des départements par puissance installée | RANK(Puissance département) ORDER BY DESC | Départementale | Mensuelle | ENEDIS/RTE + calcul | Benchmark territorial et positionnement concurrentiel | **P1** |
| **Rang départemental densité** | Classement par puissance rapportée à la superficie | RANK(Puissance/Surface département) ORDER BY DESC | Départementale | Mensuelle | ENEDIS/RTE + IGN + calcul | Maturité des marchés locaux | **P1** |
| **Part des zones rurales** | Pourcentage du parc installé en zones rurales vs urbaines | Puissance zones rurales / Puissance totale × 100 | Régionale | Trimestrielle | ENEDIS + INSEE (zonage) | Stratégies commerciales différenciées urbain/rural | **P2** |
| **Corrélation PIB/Puissance** | Coefficient de corrélation richesse-équipement PV | CORREL(PIB par habitant, Puissance par habitant) | Départementale | Trimestrielle | INSEE + ENEDIS + calcul | Ciblage socio-économique et politique tarifaire | **P2** |
| **Installations par commune** | Nombre moyen d'installations par commune équipée | Total installations / Nombre communes avec PV | Départementale | Mensuelle | ENEDIS + calcul | Maturité locale et potentiel essaimage | **P2** |
| **Taux d'équipement communes** | Pourcentage de communes ayant au moins une installation | Communes avec PV / Total communes × 100 | Départementale | Mensuelle | ENEDIS + INSEE + calcul | Diffusion territoriale et zones blanches | **P1** |
| **Puissance littorale vs intérieur** | Répartition entre départements côtiers et continentaux | Puissance départements littoraux / Puissance totale × 100 | Nationale | Trimestrielle | ENEDIS/RTE + géocodage | Attractivité climatique et foncière | **P2** |
| **Distance moyenne au réseau HTB** | Proximité moyenne aux infrastructures électriques | MOYENNE(Distance installation - Poste HTB le plus proche) | Régionale | Annuelle | RTE + ENEDIS + calcul SIG | Contraintes raccordement et coûts développement | **P2** |
| **Indice de spécialisation régional** | Sur/sous-représentation régionale vs moyenne nationale | (Part région / Part surface) / (Part nationale / Surface France) | Régionale | Trimestrielle | ENEDIS/RTE + IGN + calcul | Avantages comparatifs et positionnement régional | **P1** |

---

## Guide d'Utilisation des Priorités

### **P0 - Indicateurs Essentiels** (15 KPIs)
Indicateurs indispensables au pilotage stratégique, à intégrer en priorité dans tous les tableaux de bord direction. Ces KPIs forment le socle minimum de l'observatoire.

### **P1 - Indicateurs Importants** (15 KPIs)
Indicateurs utiles pour l'analyse opérationnelle et le pilotage des équipes commerciales et techniques. À déployer dans une seconde phase après validation du MVP.

### **P2 - Indicateurs Complémentaires** (15 KPIs)
Indicateurs d'expertise pour analyses approfondies et études sectorielles. Permettent d'affiner les stratégies une fois l'observatoire mature.

---

## Recommandations d'Implémentation

### Phase 1 - MVP (3 mois)
- **Implémenter les 15 KPIs P0** pour validation rapide de la valeur
- **Connecter ENEDIS Open Data** comme source principale
- **Créer 3 dashboards** : Vue d'ensemble, Analyse territoriale, Performance

### Phase 2 - Extension (2 mois)
- **Ajouter les 15 KPIs P1** pour enrichir l'analyse
- **Intégrer RTE et INSEE** pour données complémentaires
- **Développer alertes** sur indicateurs clés (croissance, performance)

### Phase 3 - Expertise (2 mois)
- **Déployer les 15 KPIs P2** pour analyses approfondies
- **Intégrer sources méteo et SIG** pour calculs avancés
- **Créer rapports automatisés** mensuels et trimestriels

Cette approche phasée permet une mise en œuvre progressive avec validation de la valeur à chaque étape.