# Grille des fonctionnalités à implémenter dans le cadre du projet :

## Besoin métiers :
Chaque « Order » peut avoir un ou plusieurs produits ou services rattachés.
L’utilisateur peut modifier le statut de l’order et le passer en « Actif » à tout moment. Ce fonctionnement ne convient pas au métier qui a demandé la
règle suivante : « L’utilisateur ne peut pas passer le statut de l’order en « Actif » sauf si l’order en question a des produits associés »

## Solutions à développer :
Lorsque le champ « Status » passe du statut « Draft » à « Active », un traitement trigger se déclenche pour appeler une classe apex qui vérifie que l’order en
question possède des produits. Si l’order ne possède pas de produits, la modification est bloquée et un message d’erreur invitant l’utilisateur à saisir des
produits avant d’activer l’order est affiché.
## ## ## ## ## 

## Besoin métiers :
L’order pourra être aussi relié à un compte. Lorsqu’un order est ajouté à un compte, quel que soit le statut de l’order, un champ custom « Active » est coché
automatiquement. Le besoin métier consiste à décocher la case « Active » du compte si tous les « Order » associés à ce compte sont supprimés.

## Solutions à développer :
Lorsqu’un order est supprimé, un trigger est déclenché à la suppression pour appeler une classe apex qui vérifie qu’il n’y a aucun autre order rattaché au
compte. S’il y a aucun autre order rattaché à ce compte, la case Active__c sera décochée si elle a été cochée.
## ## ## ## ## 
## Besoin métiers :
Parfois les commerciaux créent des comptes sans reprendre contact avec le client. Pour améliorer le taux de traitement des comptes créés, le métier souhaite envoyer une tâche de rappel au propriétaire de compte qui n’a aucun order rattaché. Cette activité devra être créée s’il n’y a aucune activité de type
« Appel » ajoutée au compte. Ce traitement devra se déclencher le premier Lundi de chaque mois.
## Solutions à développer :
Création d’une classe batch apex qui se déclenche le premier lundi de chaque mois qui récupère les comptes n’ayant pas d’order associés ni des tâches de rappel et crée des tâches et les rattachent à ce compte. 
Détails de la tâche à créer :
- Sujet : « Call »
- Statut : « Nouvelle »
- Priorité : « Normale »
- Rappel automatique
dans 5 jours
