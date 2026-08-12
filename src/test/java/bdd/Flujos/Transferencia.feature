Feature: Ejercicio 2 - Flujos de Transferencia de Fondos

  Background:
    # 1. Ejecutar Regresion.feature para obtener usuarios, token y saldos iniciales
    * def setup = call read('classpath:bdd/Flujos/Regresion.feature')
    * def emisor = setup.bodyEmisor
    * def receptor = setup.bodyReceptor
    * def tokenEmisor = setup.tokenEmisor
    * def saldoInicialEmisor = setup.saldoInicialEmisor

  # -------------------------------------------------------------------------
  # ESCENARIO PRINCIPAL: Transferencia Exitosa vANESSA
  # -------------------------------------------------------------------------
  Scenario: Transferencia exitosa de Emisor a Receptor via POSY y validación de saldo
    * def montoTransferencia = 450.00
    * def notaTransferencia = 'Pago de Servicios'

    # 1. Ejecutar Transferencia (Puerto 4003)
    Given url TransferUrl + 'transfer'
    And header Authorization = 'Bearer ' + tokenEmisor
    And request
    """
    {
      "phone": "#(receptor.phone)",
      "amount": #(montoTransferencia),
      "note": "#(notaTransferencia)",
      "method": "POSY"
    }
    """
    When method POST
    Then status 200
    * print 'RESPUESTA TRANSFERENCIA:', response

    # 2. Capturar ID de Transacción
    * def transactionId = response.transactionId || response.id || response.code || (response.data ? response.data.transactionId : null)
    * print 'Código de Transacción Creado:', transactionId

    # 3. Consultar Saldo del Emisor post-transferencia (Puerto 4002)
    Given url WalletUrl + 'balance'
    And header Authorization = 'Bearer ' + tokenEmisor
    And param phone = emisor.phone
    When method GET
    Then status 200
    * print 'CONSULTA SALDO NUEVO EMISOR:', response
    * def saldoNuevoEmisor = response.balance || (response.data ? response.data.balance : null)

    # 4. Validar disminución correcta de saldo (1000 - 450 = 550)
    * def saldoEsperado = saldoInicialEmisor - montoTransferencia
    And match saldoNuevoEmisor == saldoEsperado
    * print 'Saldo Inicial:', saldoInicialEmisor, '| Transferido:', montoTransferencia, '| Nuevo Saldo:', saldoNuevoEmisor


  # -------------------------------------------------------------------------
  # ESCENARIO ADICIONAL: Validación de Saldo Insuficiente
  # -------------------------------------------------------------------------
  Scenario: Error al intentar transferir un monto mayor al saldo disponible
    * def montoExcedido = 5000.00

    Given url TransferUrl + 'transfer'
    And header Authorization = 'Bearer ' + tokenEmisor
    And request
    """
    {
      "phone": "#(receptor.phone)",
      "amount": #(montoExcedido),
      "note": "Intento de transferencia excedida",
      "method": "POSY"
    }
    """
    When method POST
    # Ajustar el status esperado según las reglas de tu API (ej. 400 o 422)
    Then status 400
    * print 'RESPUESTA ERROR SALDO INSUFICIENTE:', response