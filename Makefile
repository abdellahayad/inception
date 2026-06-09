NAME = inception
DATA_PATH = /home/$(USER)/data

all: up

up:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@docker compose -f srcs/docker-compose.yml up --build -d

down:
	@docker compose -f srcs/docker-compose.yml down

clean:
	@docker compose -f srcs/docker-compose.yml down --volumes --rmi all
	@rm -rf $(DATA_PATH)

fclean: clean
	@docker system prune -a --volumes -f

re: fclean all

.PHONY: all up down clean fclean re