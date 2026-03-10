# Clone tous les projets sur github, à utiliser seulement pour la première config
clone-projects:
	git clone https://github.com/wefund-qsi/wefund-frontend.git
	git clone https://github.com/wefund-qsi/wefund-projects-service.git
	git clone https://github.com/wefund-qsi/wefund-contributions-paiements-utilisateurs.git
	git clone https://github.com/wefund-qsi/wefund-dashboard.git

# Fais le fetch de chaque projet pour le mettre à jour avec l'état donnée par l'équipe
pull-projects:
	cd wefund-frontend; git checkout main; git pull origin
	cd wefund-projects-service; git checkout main; git pull origin
	cd wefund-contributions-paiements-utilisateurs; git checkout main; git pull origin
	cd wefund-dashboard; git checkout main; git pull origin

# à ajouter: système de build généralisé pour lancer tous les composants
# peut-être ça peut être ajouté directement sur le docker compose

