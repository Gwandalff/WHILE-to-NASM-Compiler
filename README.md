# Compilation
Projet de compilation du langage WHILE vers NASM

Réalisé par JOUNEAUX Gwendal et SCHNEIDER-MAUNOURY Timothée.

# Objectif

L'objectif de ce projet est de créer un compilateur pour le langage WHILE vers un langage cible choisi par l'équipe projet en utilisant l'outil Xtext.

# Fonctionnement du compilateur

Pour pouvoir compiler un fichier WHILE, vous aurez besoin d'avoir un système linux avec NASM d'installé.

Le compilateur permet de traduire un programme .wh en fichier assembleur et en fichier executable.
Il fonctionne comme suit :  
`wh Tests/testsArithmetique.wh -o arith.out`  
Cela va créer un fichier out.asm, qui sera la traduction directe du code WHILE en assembleur. Puis le script le compile en l'exécutable arith.out. Il suffit ensuite de lancer cet exécutable, avec éventuellement des paramètres :  
`./arith.out fact 5`  

# Organisation
|---+-- Standalone    : Répertoire du compilateur  
|&#160;&#160;&#160;&#160;&#160;|-- Tests         : Répertoire des fichiers de test manuel  
|&#160;&#160;&#160;&#160;&#160;|-- Tests_Auto    : Répertoire des fichiers de test automatiques  
|&#160;&#160;&#160;&#160;&#160;\`-- wh           : Script de lancement du compilateur  
|&#160;&#160;&#160;&#160;&#160;\`-- wh.jar       : Jar permettant l'exécution du compilateur  
|&#160;&#160;&#160;&#160;&#160;\`-- wh_TestsAuto : Script de lancement des tests automatiques  
|&#160;&#160;&#160;&#160;&#160;\`-- help.txt     : Contenu de l'aide du script wh  
|&#160;&#160;&#160;&#160;&#160;\`-- testHelp.wh  : Fichier de test utilisé dans l'aide   
|  
|---+--  Documents    
|&#160;&#160;&#160;&#160;&#160;\`-- rapport-COMP-Gwendal_Jouneaux-Timothée_SchneiderMaunoury.pdf  
|&#160;&#160;&#160;&#160;&#160;\`-- Schéma-de-traduction.pdf  
|&#160;&#160;&#160;&#160;&#160;\`-- Spécification-assembleur.pdf  
|  
\`-- README.md        : Ce fichier README    

# Crédits

Cours : Olivier Ridoux

2018-2019
ESIR spécialité "Système d'Information"
