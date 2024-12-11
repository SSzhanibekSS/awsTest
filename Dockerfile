# Используем образ с Maven для сборки проекта
FROM maven:3.8.6-openjdk-17-slim AS build

# Указываем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем pom.xml и загружаем зависимости
COPY pom.xml /app
RUN mvn dependency:go-offline

# Копируем весь проект и собираем JAR файл
COPY src /app/src
RUN mvn clean package -DskipTests

# Используем официальный образ OpenJDK для запуска приложения
FROM openjdk:17-jdk-alpine

# Указываем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем собранный JAR файл из стадии сборки
COPY --from=build /app/target/awsTest-0.0.1-SNAPSHOT.jar /app/myapp.jar

# Указываем команду для запуска приложения
CMD ["java", "-jar", "myapp.jar"]

# Открываем порт для приложения (если необходимо)
EXPOSE 8080
