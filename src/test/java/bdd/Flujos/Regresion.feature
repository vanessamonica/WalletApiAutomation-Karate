@ignore
Feature: Ejercicio 1 - Registro de Usuarios y Depósito (Setup)

  Background:
    * configure headers = read('classpath:headers/registro_usuario_header.json')

  Scenario: Registrar Emisor, Receptor y Depósito de Saldos
    # 1. REGISTRO Y LOGIN DE EMISOR
    * def bodyEmisor = read('classpath:body/registro_usuario_emisor.json')
    * bodyEmisor.phone = bodyEmisor.phone || getRandomPhone()

    Given url Baseurl + 'register'
    And request bodyEmisor
    When method POST
    Then status 201

    Given url Baseurl + 'login'
    And request { "phone": '#(bodyEmisor.phone)', "pin": '#(bodyEmisor.pin)' }
    When method POST
    Then status 200
    * def tokenEmisor = response.token || response.accessToken || (response.data ? response.data.token : null)

    # 2. REGISTRO Y LOGIN DE RECEPTOR
    * def bodyReceptor = read('classpath:body/registro_usuario_receptor.json')
    * bodyReceptor.phone = bodyReceptor.phone || getRandomPhone()

    Given url Baseurl + 'register'
    And request bodyReceptor
    When method POST
    Then status 201

    Given url Baseurl + 'login'
    And request { "phone": '#(bodyReceptor.phone)', "pin": '#(bodyReceptor.pin)' }
    When method POST
    Then status 200
    * def tokenReceptor = response.token || response.accessToken || (response.data ? response.data.token : null)

    # 3. DEPOSITOS DE SALDO
    * def saldoInicialEmisor = 1000.00
    Given url WalletUrl + 'deposit'
    And header Authorization = 'Bearer ' + tokenEmisor
    And request { "phone": '#(bodyEmisor.phone)', "amount": #(saldoInicialEmisor) }
    When method POST
    Then status 200

    Given url WalletUrl + 'deposit'
    And header Authorization = 'Bearer ' + tokenReceptor
    And request { "phone": '#(bodyReceptor.phone)', "amount": 500.00 }
    When method POST
    Then status 200

    # 4. VALIDAR USUARIO DUPLICADO
    Given url Baseurl + 'register'
    And request bodyEmisor
    When method POST
    Then status 409