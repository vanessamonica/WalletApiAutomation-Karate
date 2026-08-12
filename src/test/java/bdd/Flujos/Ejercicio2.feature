Feature: Ejercicio 2 - Wallet Login

  Background:
    # Reutilizas tus encabezados
    * headers read('classpath:headers/registro_usuario_header.json')

  Scenario: Iniciar sesión correctamente

    Given url Baseurl + 'login'

    When method POST
    Then status 401

