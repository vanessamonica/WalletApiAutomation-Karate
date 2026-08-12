Feature: Ejercicio 1 - Wallet

  Background:
    * headers read('classpath:headers/registro_usuario_header.json')
    * def bodyRegistro = read('classpath:body/registro_usuario.json')

  Scenario: Registrar usuario correctamente

    Given url Baseurl + 'register'
    And request bodyRegistro
    When method POST
    Then status 201
    And match response.message == 'Usuario creado exitosamente'
    * print 'Respuesta:', response
