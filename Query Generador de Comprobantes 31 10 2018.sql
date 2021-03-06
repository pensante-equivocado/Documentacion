USE [eFacturacionTCI]
GO
/****** Object:  StoredProcedure [Facturacion].[usp_Comprobante_ProcesarAutomaticoseFacturacion]    Script Date: 31/10/2018 12:13:47 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

SELECT * FROM Facturacion.ContratoeFacturacionPlanFacturacionDescuentoPse

SELECT * FROM Facturacion.ContratoeFacturacionPlanFacturacionDescuentoOse



/*
******************************************************************************************
PROCEDIMIENTO MODIFICADO
TRAFICO PSE Y OSE; ANTES DE PROCESAR VALIDAR QUE NO SE HAYA IMPORTADO NINGUNO O ESTEN LOS 2 IMPORTADOS EN CUANTO A TRAFICO
******************************************************************************************
*/
--ALTER PROCEDURE [Facturacion].[usp_Comprobante_ProcesarAutomaticoseFacturacion] (
--	@MesGeneracion				VARCHAR(2)
--	,@AnioGeneracion			VARCHAR(4)
--	,@TbPreviaPse				Facturacion.Temp_ContratoGenerar READONLY --previaPse
--	,@TbContratosVsConsumosPse	Facturacion.Temp_ListaConsumosEnProceso READONLY --dtContratosVsConsumosPse
--	,@TbPreviaOse				Facturacion.Temp_ContratoGenerarOse READONLY --previaOse
--	,@TbContratosVsConsumosOse	Facturacion.Temp_ListaConsumosEnProcesoOse READONLY --dtContratosVsConsumosOse
--	)
--AS
--BEGIN
	SET LANGUAGE SPANISH
	SET DATEFORMAT DMY
	SET DATEFIRST 1
	--Toma el ultimo numero actual de la tabla TipoComprobante y le agrega 1
	DECLARE @MesGeneracion VARCHAR(2)
	DECLARE @AnioGeneracion VARCHAR(4)
	DECLARE @TbPreviaPse Facturacion.Temp_ContratoGenerar
	DECLARE @TbContratosVsConsumosPse Facturacion.Temp_ListaConsumosEnProceso
	DECLARE @TbPreviaOse Facturacion.Temp_ContratoGenerarOse
	DECLARE @TbContratosVsConsumosOse Facturacion.Temp_ListaConsumosEnProcesoOse

	SET @MesGeneracion = '9'
	SET @AnioGeneracion = '2018'

	INSERT INTO @TbPreviaPse VALUES(1,700,5,0,4000,1944.29,1,0,'31/10/2018',1,1805,15,17,27,268,'70410018',2898,'40111000',18.00,'12120001',160086,NULL,32,0,0)

	INSERT INTO @TbContratosVsConsumosPse VALUES(700,8302)
	INSERT INTO @TbContratosVsConsumosPse VALUES(700,8301)
	INSERT INTO @TbContratosVsConsumosPse VALUES(700,8300)
	INSERT INTO @TbContratosVsConsumosPse VALUES(700,8299)

												--por adelantado, mes anterior
	INSERT INTO @TbPreviaOse VALUES(1,8,5,0,5000,0,0,0,'31/10/2018',1,1805,15,17,45,607,'74112008',2898,'40111000',18.00,'12120001',0,NULL,32,0,0)

	INSERT INTO @TbContratosVsConsumosOse VALUES(8,0)

	--SELECT * FROM @TbPreviaPse
	--SELECT * FROM @TbPreviaOse
	--SELECT * FROM @TbContratosVsConsumosPse
	--SELECT * FROM @TbContratosVsConsumosOse

	--SET NOCOUNT ON

	/*************************************************************************************************************************
	VARIABLES EXTRAIDAS DE LA VARIABLE @TbPreviaPse POR CADA ITERACION
	*************************************************************************************************************************/ 
	DECLARE @IdContratoeFacturacion INT
	DECLARE @CargoBasicoPse DECIMAL(12, 4)
	DECLARE @SubtotalPse DECIMAL(12, 4)
	DECLARE @MontoExcedenteFinalPse DECIMAL(12, 4)
	DECLARE @FacturaPorAdelantadoPse BIT
	DECLARE @FacturaMesAnteriorPse BIT
	DECLARE @FechaGeneradoPse DATETIME
	DECLARE @IdMonedaPse INT
	DECLARE @IdClientePse INT
	DECLARE @PlazoDiasPse INT
	DECLARE @IdAsesorComercialPse INT
	DECLARE @IdServicioPse INT
	DECLARE @IdTarifaPse INT
	DECLARE @CuentaContablePse VARCHAR(18)
	DECLARE @IdTipoCambioPse INT
	DECLARE @CuentaIgvPse VARCHAR(18)
	DECLARE @TasaIgvPse DECIMAL(9, 2) --18.00
	DECLARE @CuentaComprobanteMonedaPse VARCHAR(18)
	DECLARE @SumaCantidadDocumentosPse INT
	DECLARE @IdContactoPse INT
	DECLARE @IdContratoeFacturacionGeneralPse INT
	DECLARE @GeneradoPse VARCHAR(1)
	DECLARE @CantComprobantesEmitidosPse INT
	

	/*************************************************************************************************************************
	VARIABLES EXTRAIDAS DE LA VARIABLE @TbPreviaOse POR CADA ITERACION
	*************************************************************************************************************************/ 
	DECLARE @IdContratoOse INT
	DECLARE @CargoBasicoOse DECIMAL(12, 4)
	DECLARE @SubtotalOse DECIMAL(12, 4)
	DECLARE @MontoExcedenteFinalOse DECIMAL(12, 4)
	DECLARE @FacturaPorAdelantadoOse BIT
	DECLARE @FacturaMesAnteriorOse BIT
	DECLARE @FechaGeneradoOse DATETIME
	DECLARE @IdMonedaOse INT
	DECLARE @IdClienteOse INT
	DECLARE @PlazoDiasOse INT
	DECLARE @IdAsesorComercialOse INT
	DECLARE @IdServicioOse INT
	DECLARE @IdTarifaOse INT
	DECLARE @CuentaContableOse VARCHAR(18)
	DECLARE @IdTipoCambioOse INT
	DECLARE @CuentaIgvOse VARCHAR(18)
	DECLARE @TasaIgvOse DECIMAL(9, 2) --18.00
	DECLARE @CuentaComprobanteMonedaOse VARCHAR(18)
	DECLARE @SumaCantidadDocumentosOse INT
	DECLARE @IdContactoOse INT
	DECLARE @IdContratoeFacturacionGeneralOse INT
	DECLARE @GeneradoOse VARCHAR(1)
	DECLARE @CantComprobantesEmitidosOse INT
	

	/***********************************************************************************************************************************
	VARIABLES CONSTANTES
	***********************************************************************************************************************************/
	DECLARE @ConstMesGeneracion VARCHAR(2)		--Mes seleccionado en el control del aplicativo
	DECLARE @ConstAnioGeneracion VARCHAR(4)		--Año seleccionado en el control del aplicativo
	DECLARE @ConstEsReservado BIT				--Si la tabla DetalleConsumo no tiene registros entonces sera 1(true), al ser reservado podria ser modificado posteriormente
	DECLARE @ConstIdTipoComprobante INT			--Siempre sera 5 Factura

	SET @ConstEsReservado			= 0
	SET @ConstIdTipoComprobante		= 5

	--No se valida OSE debido a que antes de procesar, se debe preguntar si estan importados los 2 o ninguno; en caso que solo este importado uno de ellos no debe proceder
	IF ((SELECT COUNT(IdDetalleConsumoeFacturacion) FROM Facturacion.DetalleConsumoeFacturacion 
	where Mes = Cast(Cast(@MesGeneracion as INT) as varchar(2)) and Anio = @AnioGeneracion) = 0)
	BEGIN
		--Todos los comprobantes se generaran como estado reservado(monto minimo)
		SET @ConstEsReservado = 1
	END

	SET @MesGeneracion				= RIGHT('00' + @MesGeneracion, 2)
	SET @ConstMesGeneracion			= @MesGeneracion 
	SET @ConstAnioGeneracion		= @AnioGeneracion 

	/***********************************************************************************************************************************
	LOG'S Y TABLA QUE CONTENDRA LOS COMPROBANTES GENERADOS(SE RETORNARA)
	***********************************************************************************************************************************/
	DECLARE @Temp_LogInsertado NVARCHAR(MAX)
	DECLARE @Temp_Log NVARCHAR(MAX)
	DECLARE @TempTablaComprobantesInsertados TABLE (IdComprobanteInsertado INT
													,ComprobanteInsertado VARCHAR(20)
													,IdContratoInsertado INT
													,IdContratoOseInsertado INT
													,LogInsertado NVARCHAR(MAX)
													);
	DECLARE @CantidadProcesados INT
	SET @CantidadProcesados = 0

	/***********************************************************************************************************************************
	VARIABLES GENERALES
	***********************************************************************************************************************************/
	DECLARE @ContadorPse INT						--Iteracion del bucle WHILE PSE
	DECLARE @TotalFilasPse INT						--Total de vueltas del bucle(total filas de la variable @TbPreviaPse)
	DECLARE @ContadorOse INT						--Iteracion del bucle WHILE OSE
	DECLARE @TotalFilasOse INT						--Total de vueltas del bucle(total filas de la variable @TbPreviaOse)
	DECLARE @Serie VARCHAR(4)						--Siempre sera 'F001', perteneciente a la serie del idtipocomprobante 5
	DECLARE @NroComprobanteActual INT				--Obtiene el ultimo numero usado en la tabla TipoComprobante y le suma 1
	DECLARE @NroComprobante VARCHAR(8)				--Convierte la variable @NroComprobanteActual en texto de 8 caracteres
	DECLARE @MvtoCorrelativoActual INT				--Obtiene en tabla Comprobante el mayor numero y le suma 1(filtro por mes y año)
	DECLARE @MvtoCorrelativo VARCHAR(4)				--Convierte la variable @MvtoCorrelativoActual en texto de 4 caracteres
	DECLARE @IdComprobante INT						--Obtiene el IdComprobante maximo y le suma 1
	DECLARE @MesCorrelativoComprobante VARCHAR(2)	--Obtiene el mes de la fecha de generacion (puede ser el mes actual o el anterior)
	DECLARE @AnioCorrelativoComprobante VARCHAR(4)	--Obtiene el año de la fecha de generacion (puede ser el año actual o el anterior)
	DECLARE @PorcDetraccion DECIMAL(9, 2)			--Obtiene el porcentaje segun el @IdTarifa
	DECLARE @TipoCambio DECIMAL(12, 4)				--Obtiene el tipo de cambio segun el IdTipoCambio del parametro @TbPreviaPse
	
	DECLARE @CompDetPseMontoSoles DECIMAL(12, 4)				--Obtiene el monto segun el cargo basico, el subtotal y el tipo de cambio de la tabla @TbPreviaPse
	DECLARE @CompDetPseMontoDolares DECIMAL(12, 4)				--Obtiene el monto segun el cargo basico, el subtotal y el tipo de cambio de la tabla @TbPreviaPse
	DECLARE @CompDetPseMontoExcedenteSoles DECIMAL(12, 4)		--Obtiene el monto segun el MontoExcedenteFinal y el tipo de cambio de la tabla @TbPreviaPse
	DECLARE @CompDetPseMontoExcedenteDolares DECIMAL(12, 4)		--Obtiene el monto segun el MontoExcedenteFinal y el tipo de cambio de la tabla @TbPreviaPse
	DECLARE @CompDetOseMontoSoles DECIMAL(12, 4)				--Obtiene el monto segun el cargo basico, el subtotal y el tipo de cambio de la tabla @TbPreviaOse
	DECLARE @CompDetOseMontoDolares DECIMAL(12, 4)				--Obtiene el monto segun el cargo basico, el subtotal y el tipo de cambio de la tabla @TbPreviaOse
	DECLARE @CompDetOseMontoExcedenteSoles DECIMAL(12, 4)		--Obtiene el monto segun el MontoExcedenteFinal y el tipo de cambio de la tabla @TbPreviaOse
	DECLARE @CompDetOseMontoExcedenteDolares DECIMAL(12, 4)		--Obtiene el monto segun el MontoExcedenteFinal y el tipo de cambio de la tabla @TbPreviaOse
	
	DECLARE @EsDescuento CHAR(1)					--Obtiene el valor booleano segun el IdTarifa de la tabla @TbPreviaPse
	DECLARE @IterDetalle INT						--Iteracion del bucle de los detalles (cantidad de detalles que contendra)
	DECLARE @TotaDetalle INT						--Total detalles (cantidad de detalles que contendra)
	DECLARE @Accion VARCHAR(20)						--upd, new
	DECLARE @Emitir INT								--El comprobante se emitira si es 1
	
	DECLARE @Temp_IdDetalleConsumoeFacturacion		--Contiene los IdDetalleConsumoeFacturacion del contrato (en cada iteracion tiene nuevos datos)
	TABLE (											--Al final del proceso los id que esten en esta variable son los que
		IdDetalleConsumo INT						--su estado de Procesado se modificaran a '1'
		) 
	
	DECLARE @IdDetalleConsumoCantidad INT			--Cantidad de filas de la tabla @Temp_IdDetalleConsumoeFacturacion

	--CASILLAS INVOLUCRADAS
	DECLARE @TbCasillasConsumidasPorContrato TABLE(	--Item,IdDetalleConsumoeFacturacion,Casilla; inner join entre @TbContratosVsConsumosPse y DetalleConsumo
		Item INT									--filtrados por el IdContrato
		,IdConsumo INT
		,Casilla NVARCHAR(50)
		)
	DECLARE @AcumCasilla VARCHAR(250)				--Concatena todas las casillas por IdContrato de @TbContratosVsConsumosPse INNER JOIN DetalleConsumo (casilla1,casilla2,casilla3), para insertarlos en el detalle del comprobante

	SET @ContadorPse = 1
	SET @TotalFilasPse = (SELECT COUNT(Item)FROM @TbPreviaPse)
	DECLARE @Numeracion2doItemPorAdelantado INT		--Correlativo de item de los detalles
	DECLARE @FechaMesParametro DATETIME
	DECLARE @FechaMesSiguienteAlParametro DATETIME

	DECLARE @MensajeCantidadDocumentosPse VARCHAR(100)
	DECLARE @DescripcionItem1_MesSiguientePse VARCHAR(1500)
	DECLARE @DescripcionItem2_MesParametroPse VARCHAR(1500)
	DECLARE @DescripcionItem3_MesParametroPse VARCHAR(1500)
	DECLARE @MensajeCantidadDocumentosOse VARCHAR(100)
	DECLARE @DescripcionItem1_MesSiguienteOse VARCHAR(1500)
	DECLARE @DescripcionItem2_MesParametroOse VARCHAR(1500)
	DECLARE @DescripcionItem3_MesParametroOse VARCHAR(1500)
	DECLARE @DetalleComprobante Facturacion.TempComprobanteDetalle

	/***********************************************************************************************************************************
	LISTAR LOS CONTRATOS OSE QUE NO TIENEN PSE; ESTAS FACTURAS SOLO TIENEN DETALLE OSE
	***********************************************************************************************************************************/
	DECLARE @TbPreviaOseSinPse Facturacion.Temp_ContratoGenerarOse;
	WITH TempContratosOseSinPse
	AS(
		SELECT ose.* FROM @TbPreviaOse ose
		LEFT JOIN @TbPreviaPse pse ON ose.IdContratoeFacturacionGeneral = pse.IdContratoeFacturacionGeneral
		WHERE pse.IdContratoeFacturacionGeneral is null
	)

	INSERT INTO @TbPreviaOseSinPse(
		Item
		,IdContratoOse
		,IdTipoComprobante
		,CargoBasico
		,Subtotal
		,MontoExcedenteFinal
		,FacturaPorAdelantado
		,FacturaMesAnterior
		,FechaGenerado
		,IdMoneda
		,IdCliente
		,PlazoDias
		,IdAsesorComercial
		,IdServicio
		,IdTarifa
		,CuentaContable
		,IdTipoCambio
		,CuentaIgv
		,TasaIgv --18.00
		,CuentaComprobanteMoneda
		,SumaCantidadDocumentos
		,IdContacto
		,IdContratoeFacturacionGeneral
		,Generado
		,CantComprobantesEmitidos
		)
	SELECT	ROW_NUMBER() OVER(ORDER BY temp.IdContratoeFacturacionGeneral)
			,temp.IdContratoOse
			,temp.IdTipoComprobante
			,temp.CargoBasico
			,temp.Subtotal
			,temp.MontoExcedenteFinal
			,temp.FacturaPorAdelantado
			,temp.FacturaMesAnterior
			,temp.FechaGenerado
			,temp.IdMoneda
			,temp.IdCliente
			,temp.PlazoDias
			,temp.IdAsesorComercial
			,temp.IdServicio
			,temp.IdTarifa
			,temp.CuentaContable
			,temp.IdTipoCambio
			,temp.CuentaIgv
			,temp.TasaIgv --18.00
			,temp.CuentaComprobanteMoneda
			,temp.SumaCantidadDocumentos
			,temp.IdContacto
			,temp.IdContratoeFacturacionGeneral
			,temp.Generado
			,temp.CantComprobantesEmitidos
	FROM TempContratosOseSinPse temp
			
	--SELECT * FROM @TbPreviaOseSinPse
	--Item	IdContratoOse	IdTipoComprobante	CargoBasico	Subtotal	MontoExcedenteFinal	FacturaPorAdelantado	FacturaMesAnterior	FechaGenerado	IdMoneda	IdCliente	PlazoDias	IdAsesorComercial	IdServicio	IdTarifa	CuentaContable	IdTipoCambio	CuentaIgv	TasaIgv	CuentaComprobanteMoneda	SumaCantidadDocumentos	IdContacto	IdContratoeFacturacionGeneral	Generado	CantComprobantesEmitidos
	--1		33				5					0.0000		12.0000		0.0000				0						1					2017-12-30		1			2336		12			26					31			340			74112008		2575			40111000	18.00	12120001				0						NULL		569								0			0
	--2		30				5					0.0000		300.0000	0.0000				0						1					2017-12-30		1			2336		15			26					31			293			70410008		2575			40111000	18.00	12120001				0						NULL		573								0			0
	
	SET @TotalFilasOse = (SELECT COUNT(Item)FROM @TbPreviaOseSinPse)

	/***********************************************************************************************************************************
	INICIO DE BUCLE DE LOS REGISTROS DE @TbPreviaPse
	***********************************************************************************************************************************/
	DECLARE @IdContratoOseAsociadaAlPse INT
	DECLARE @TbIncluirOse Facturacion.Temp_ContratoGenerarOse

	WHILE @ContadorPse <= @TotalFilasPse
	BEGIN
		--BEGIN TRY
			--BEGIN TRANSACTION

			SET @Temp_Log = ''
			SET @Temp_LogInsertado = ''
			SET @MesCorrelativoComprobante = ''
			SET @AnioCorrelativoComprobante = ''
			SET @Accion = 'new'
			SET @Emitir = 0
			SET @PorcDetraccion = 0

			/***********************************************************************************************************************************
			OBTIENE LOS DATOS FILA X FILA DEL PARAMETRO @TbPreviaPse
			***********************************************************************************************************************************/
			SELECT @Serie = Tcomprob.Serie
				,@NroComprobanteActual = (CAST(ISNULL(Tcomprob.NumeroActual, 0) AS INT) + 1)	--Toma el ultimo numero actual de la tabla TipoComprobante y le agrega 1
				,@IdContratoeFacturacion = Tbl.IdContratoeFacturacion
				,@CargoBasicoPse = Tbl.CargoBasico
				,@SubtotalPse = Tbl.Subtotal
				,@MontoExcedenteFinalPse = Tbl.MontoExcedenteFinal
				,@FacturaPorAdelantadoPse = Tbl.FacturaPorAdelantado								--Flag
				,@FacturaMesAnteriorPse = Tbl.FacturaMesAnterior									--Flag
				,@FechaGeneradoPse = Tbl.FechaGenerado												--La fecha varia si es de mes anterior o del presente
				,@IdMonedaPse = Tbl.IdMoneda														--1	Nuevo Sol ; 2 Dolar                                                                        
				,@IdClientePse = Tbl.IdCliente
				,@PlazoDiasPse = Tbl.PlazoDias
				,@IdAsesorComercialPse = Tbl.IdAsesorComercial
				,@IdServicioPse = Tbl.IdServicio
				,@IdTarifaPse = Tbl.IdTarifa
				,@CuentaContablePse = Tbl.CuentaContable
				,@IdTipoCambioPse = Tbl.IdTipoCambio
				,@TipoCambio = Tcam.TipoCambio
				,@CuentaIgvPse = Tbl.CuentaIgv
				,@TasaIgvPse = CAST(ROUND(Tbl.TasaIgv, 2) AS DECIMAL(9, 2))						--Porcentaje Igv 18.00 %
				,@CuentaComprobanteMonedaPse = Tbl.CuentaComprobanteMoneda
				,@SumaCantidadDocumentosPse = Tbl.SumaCantidadDocumentos							--Lo Obtiene del detalleconsumo
				,@GeneradoPse = Tbl.Generado														--Flag que indicara si esta reservado(0) o generado(1)
				,@CantComprobantesEmitidosPse = Tbl.CantComprobantesEmitidos						--Obtiene la cantidad de facturas del contrato que se hayan emitido en el mes
				,@IdContactoPse = Tbl.IdContacto
				,@IdContratoeFacturacionGeneralPse = Tbl.IdContratoeFacturacionGeneral
			FROM @TbPreviaPse Tbl
			INNER JOIN Maestro.TipoComprobante Tcomprob ON Tbl.IdTipoComprobante = Tcomprob.IdTipoComprobante
			INNER JOIN Maestro.TipoCambio Tcam ON tbl.IdTipoCambio = Tcam.IdTipoCambio
			WHERE Tbl.Item = @ContadorPse;

			/***********************************************************************************************************************************
			PROCESO
			
			SI GENERADOPSE ES '1', ENTONCES YA ESTA GENERADO EL COMPROBANTE DEL CONTRATO
			SI GENERADOPSE ES '0', ENTONCES SE VALIDA @CantComprobantesEmitidos, EN CASO SEA MAYOR A 1 SE DEBERA MODIFICAR EL COMPROBANTE
								PERO SI @CantComprobantesEmitidos ES CERO ENTONCES SE CREARA UN NUEVO COMPROBANTE
			@SumaCantidadDocumentosPse = catnidad de facturas transmitidas + boketas + nc + nd + etc... del detalle consumo e facturacion
			***********************************************************************************************************************************/
			IF @GeneradoPse = '1'
			BEGIN

				SET @Temp_Log = '||EL CONTRATO CON ID ' + CAST(@IdContratoeFacturacion AS VARCHAR) + ' YA TIENE COMPROBANTE GENERADO ||';
				SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log
				PRINT @Temp_Log

			END
			ELSE --IF @GeneradoPse = '0'
			BEGIN
				/***********************************************************************************************************************************
				- Casillas involucradas, concatena las casillas, posteriormente las agrega al detalle de comprobante
				***********************************************************************************************************************************/
				IF @SumaCantidadDocumentosPse > 0--en caso en el detalle consumo efacturacion existan conteos de trafico
				BEGIN
					SET @IterDetalle = 1
					SET @AcumCasilla = ''

					DELETE
					FROM @TbCasillasConsumidasPorContrato

					INSERT INTO @TbCasillasConsumidasPorContrato
					SELECT ROW_NUMBER() OVER (
							ORDER BY tbdetcons.IdDetalleConsumoeFacturacion ASC
							) AS Item
						,tbdetcons.IdDetalleConsumoeFacturacion
						,detconfact.Casilla
					FROM @TbContratosVsConsumosPse tbdetcons
					INNER JOIN Facturacion.DetalleConsumoeFacturacion detconfact ON tbdetcons.IdDetalleConsumoeFacturacion = detconfact.IdDetalleConsumoeFacturacion
					WHERE tbdetcons.IdContratoeFacturacion = @IdContratoeFacturacion;

					SELECT @TotaDetalle = COUNT(Item)
					FROM @TbCasillasConsumidasPorContrato;

					WHILE @IterDetalle <= @TotaDetalle
					BEGIN
						SET @AcumCasilla = @AcumCasilla + (
								SELECT TOP 1 Casilla
								FROM @TbCasillasConsumidasPorContrato
								WHERE Item = @IterDetalle
								) + ', '
						SET @IterDetalle = @IterDetalle + 1
					END

					SET @Temp_Log = ' * CASILLAS (DETALLE DE CONSUMO): ' + @AcumCasilla + '||'
					SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log

					PRINT @Temp_Log
				END
				ELSE
				BEGIN
					SET @Temp_Log = ' * CASILLAS (DETALLE DE CONSUMO): NO SE HALLARON CASILLAS EN [DETALLE DE CONSUMO] PARA ESTE CONTRATO||'
					SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log

					PRINT @Temp_Log
				END
				
				/***********************************************************************************************************************************
				Valida si @Accion sera actualizar(upd) o nuevo(new)
				- Si @CantComprobantesEmitidos > 0, significa que en la tabla [Facturacion].[ContratoControleFacturacion] ya existe registrado el contrato contra un comprobante
				- @FechaGenerado puede ser del mes-año anterior o actual
				- Si @Emitir es 0, entonces, en sus detallesconsumo ya figuran como procesados y es que en el parametro @TbContratosVsConsumosPse no existen registros(casillas) del contrato	
				- Si @Emitir es 1, entonces debe emitir un comprobante
				***********************************************************************************************************************************/
				SET @Accion = CASE WHEN (@CantComprobantesEmitidosPse > 0) THEN 'upd' ELSE 'new' END;
				SET @MesCorrelativoComprobante = RIGHT('00' + CAST(MONTH(@FechaGeneradoPse) AS VARCHAR(2)), 2)		
				SET @AnioCorrelativoComprobante = RIGHT('0000' + CAST(YEAR(@FechaGeneradoPse) AS VARCHAR(4)), 4)	

				--La cantidad de registros del detalle consumo por contrato; pero que no hayan sido procesados
				--Si emitir = 0, no tiene trafico consumo ó todos sus detalles consumos ya fueron procesados
				SELECT @Emitir = COUNT(detCon.IdDetalleConsumoeFacturacion)
				FROM Facturacion.DetalleConsumoeFacturacion detCon
				WHERE detCon.IdDetalleConsumoeFacturacion IN (SELECT TB2.IdDetalleConsumoeFacturacion 
																FROM @TbContratosVsConsumosPse TB2 
																WHERE TB2.IdContratoeFacturacion = @IdContratoeFacturacion)
						AND ISNULL(detCon.Procesado, 0) = 0;

				/***********************************************************************************************************************************
				Se actualiza los contratos que ya tengan comprobante
				***********************************************************************************************************************************/
				IF @CantComprobantesEmitidosPse > 0 AND @GeneradoPse = '0' AND @Accion = 'upd'
				BEGIN					
					SET @Emitir = 1
				END

				/***********************************************************************************************************************************
				- Validando si es un contrato activo que no tenga consumo; solo se facturara cargo basico mas monto minimo
				- Si emitir es 0 (si sigue siendo cero no se generara comprobante) y en @TbContratosVsConsumosPse no existe registro de IdDetalleConsumo
				***********************************************************************************************************************************/
				IF @Emitir = 0 AND ((SELECT TOP 1 TB2.IdDetalleConsumoeFacturacion 
									 FROM @TbContratosVsConsumosPse TB2 
									 WHERE TB2.IdContratoeFacturacion = @IdContratoeFacturacion) = 0)
				BEGIN
					IF @CantComprobantesEmitidosPse = 0 --en caso no tenga detalle o cantidad de trafico en detalle consumo
					BEGIN
						SET @Temp_Log = '||EL CONTRATO CON ID ' + CAST(@IdContratoeFacturacion AS VARCHAR) + ' NO POSEE CONSUMO PERO SE EMITIRA CON EL MONTO MINIMO||';
						SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log

						PRINT @Temp_Log

						SET @Emitir = 1
						--SI @Emitir = 1, ENTONCES SE PROCEDERA A EFECTUAR EL COMPROBANTE
					END
				END

				/***********************************************************************************************************************************
				Algunas empresas tendran mas de un contrato (habra consumo por parte de la entidad); 
				Pero el primer contrato tomara la casilla con su consumo y emitira su comprobante; el segundo contrato debera efectuar
				un comprobante a pesar de que el flag de la empresa en detalle consumo esta en 1 (procesado); este monto sera 
				el cargo basico + el monto minimo
				La validacion general es 'emitir = 0 y tiene DetalleConsumo'
				***********************************************************************************************************************************/
				IF @Emitir = 0 AND ((SELECT TOP 1 TB2.IdDetalleConsumoeFacturacion 
									 FROM @TbContratosVsConsumosPse TB2 
									 WHERE TB2.IdContratoeFacturacion = @IdContratoeFacturacion) != 0)
				BEGIN
					IF @CantComprobantesEmitidosPse = 0 --es un campo de la variable estructural @TbContratosVsConsumosPse
					BEGIN
						SET @Temp_Log = '||LA EMPRESA CON EL CONTRATO ID ' + CAST(@IdContratoeFacturacion AS VARCHAR) + ' SI POSEE CONSUMO PERO SE DOCUMENTO EN UN COMPROBANTE CON OTRO CONTRATO';
						SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log

						PRINT @Temp_Log

						SET @Emitir = 1
						--SI NO EXISTE CONSUMO, ENTONCES NO HAY DOCUMENTOS NI MONTO EXCESO
						SET @SumaCantidadDocumentosPse = 0
						SET @MontoExcedenteFinalPse = 0
							--SI @Emitir = 1, ENTONCES SE PROCEDERA A EFECTUAR EL COMPROBANTE
					END
				END

				/***********************************************************************************************************************************
				Solo si @Emitir es 1 se generan los comprobantes
				***********************************************************************************************************************************/
				IF @Emitir > 0
				BEGIN
										
					PRINT CHAR(13) + CHAR(10) + 'EVALUANDO QUE NO ESTEN LOS CHECK DE FACTURARMESANTERIOR Y FACTURARPORADELANTADO MARCADOS A LA VEZ'

					IF @FacturaMesAnteriorPse = 1 AND @FacturaPorAdelantadoPse = 1
					BEGIN
						PRINT 'FACTURARMESANTERIOR Y FACTURARPORADELANTADO NO PUEDEN ESTAR MARCADOS A LA VEZ; ' + CAST(@ContadorPse AS VARCHAR);
					END
					ELSE
					BEGIN
						SET @Temp_Log = '||REGISTRANDO COMPROBANTE N°' + CAST(@ContadorPse AS VARCHAR) + '||';
						SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log

						PRINT @Temp_Log

						/***********************************************************************************************************************************
						PROCESAR CABECERA DEL COMPROBANTE
						***********************************************************************************************************************************/
						SET @IdComprobante = NULL
						IF @Accion = 'new' --genera nuevo numero de comprobante
						BEGIN
							SET @NroComprobante = (RIGHT('00000000' + CAST(@NroComprobanteActual AS VARCHAR), 8))

							--(CAST(ISNULL(MAX(MovimientoCorrelativo), '0') AS INT) + 1)

							SET @MvtoCorrelativoActual = (
									SELECT (CAST(ISNULL(MAX(MovimientoCorrelativo), 0) AS INT) + 1)
									FROM Facturacion.Comprobante
									WHERE NroMovimientoxMes = @MesCorrelativoComprobante AND NroMovimientoxAnio = @AnioCorrelativoComprobante
									)
							SET @MvtoCorrelativo = (RIGHT('0000' + CAST(@MvtoCorrelativoActual AS VARCHAR), 4))
							
							SET @IdComprobante = (SELECT (MAX(ISNULL(IdComprobante, 0)) + 1) FROM Facturacion.Comprobante);
						END

						IF @Accion = 'upd'
						BEGIN
							--IdAsesorComercial = @IdAsesorComercial
							--IdComprobante = @IdComprobante

							SET @IdComprobante = (SELECT IdComprobante FROM Facturacion.Comprobante 
							WHERE MesFacturacion = @ConstMesGeneracion AND 
							AnioFacturacion = @ConstAnioGeneracion AND
							IdContratoeFacturacion = @IdContratoeFacturacion AND
							IdEstado = 7)

						END

						IF @IdComprobante IS NOT NULL --SI ES NUEVO-SACA EL MAXIMO Y LE AGREGA + 1; SI ES MODIFICAR-MEDIANTE UN SELECT DEL CONTRATO SE OBTIENE EL ID
						BEGIN
							
							IF @IdComprobante > 0
							BEGIN
								
								--Con el id PSE hallo el idgeneral, posteriormente con ese id obtengo el idcontrato OSE; 
								--ese id debe guardarse en la tabla de comprobantes (IdContratoeFacturacionOse)
								
								SET @IdContratoOseAsociadaAlPse = NULL
								SELECT @IdContratoOseAsociadaAlPse = IdContratoOse 
								FROM @TbPreviaOse 
								WHERE IdContratoeFacturacionGeneral =
								(SELECT TOP 1 IdContratoeFacturacionGeneral 
								 FROM @TbPreviaPse 
								 WHERE IdContratoeFacturacion = @IdContratoeFacturacion)

								--La accion determina new o upd
								EXEC [Facturacion].[usp_Comprobante_ins_Automatica_eFacturacion_test3]
									@Accion							--es el mismo tanto para PSE como para OSE
									,@IdComprobante					--es el mismo tanto para PSE como para OSE
									,@AnioCorrelativoComprobante	--es el mismo tanto para PSE como para OSE
									,@MesCorrelativoComprobante		--es el mismo tanto para PSE como para OSE
									,@MvtoCorrelativo				--es el mismo tanto para PSE como para OSE
									,@CuentaComprobanteMonedaPse	--es el mismo tanto para PSE como para OSE
									,@FechaGeneradoPse				--es el mismo tanto para PSE como para OSE
									,@IdClientePse					--es el mismo tanto para PSE como para OSE
									,@IdMonedaPse					--es el mismo tanto para PSE como para OSE
									,@Serie							--es el mismo tanto para PSE como para OSE
									,@NroComprobante				--es el mismo tanto para PSE como para OSE
									,@CuentaIgvPse					--es el mismo tanto para PSE como para OSE
									,@TasaIgvPse					--es el mismo tanto para PSE como para OSE
									,@IdTipoCambioPse				--es el mismo tanto para PSE como para OSE
									,@PlazoDiasPse					--es el mismo tanto para PSE como para OSE
									,@IdContratoeFacturacion
									,@IdAsesorComercialPse			--es el mismo tanto para PSE como para OSE
									,@ConstMesGeneracion			--es el mismo tanto para PSE como para OSE
									,@ConstAnioGeneracion			--es el mismo tanto para PSE como para OSE
									,@ConstEsReservado				--es el mismo tanto para PSE como para OSE
									,@IdContactoPse 
									,@IdContratoOseAsociadaAlPse--@IdContratoOse
							

								EXEC Facturacion.usp_Comprobante_upd_DireccionEntrega @IdComprobante;

								/***********************************************************************************************************************************
								PROCESAR DETALLE DEL COMPROBANTE
								***********************************************************************************************************************************/
								--Obtengo por el idcontratogeneral de la tabla pse el registro de ose
								DELETE FROM @TbIncluirOse;
								INSERT INTO @TbIncluirOse
								SELECT * FROM @TbPreviaOse ose WHERE ose.IdContratoOse = @IdContratoOseAsociadaAlPse --ose.IdContratoeFacturacionGeneral = @IdContratoeFacturacionGeneralPse

								/***********************************************************************************************************************************
								OBTIENE LOS DATOS FILA X FILA DEL PARAMETRO 
								***********************************************************************************************************************************/
								SET @IdContratoOse = NULL
								SET @CargoBasicoOse = NULL
								SET @SubtotalOse = NULL
								SET @MontoExcedenteFinalOse = NULL
								SET @FacturaPorAdelantadoOse = NULL
								SET @FacturaMesAnteriorOse = NULL
								SET @IdAsesorComercialOse = NULL
								SET @IdServicioOse = NULL
								SET @IdTarifaOse = NULL
								SET @CuentaContableOse = NULL
								SET @CuentaIgvOse = NULL
								SET @CuentaComprobanteMonedaOse = NULL
								SET @SumaCantidadDocumentosOse = NULL
								SET @GeneradoOse = NULL
								SET @CantComprobantesEmitidosOse = NULL

								if ((SELECT COUNT(IdContratoOse) FROM @TbIncluirOse) > 0)
								BEGIN
									SELECT	@IdContratoOse = Tbl.IdContratoOse
											,@CargoBasicoOse = Tbl.CargoBasico
											,@SubtotalOse = Tbl.Subtotal
											,@MontoExcedenteFinalOse = Tbl.MontoExcedenteFinal
											,@FacturaPorAdelantadoOse = Tbl.FacturaPorAdelantado								--Flag
											,@FacturaMesAnteriorOse = Tbl.FacturaMesAnterior									--Flag
											,@IdAsesorComercialOse = Tbl.IdAsesorComercial
											,@IdServicioOse = Tbl.IdServicio
											,@IdTarifaOse = Tbl.IdTarifa
											,@CuentaContableOse = Tbl.CuentaContable
											,@CuentaIgvOse = Tbl.CuentaIgv
											,@CuentaComprobanteMonedaOse = Tbl.CuentaComprobanteMoneda
											,@SumaCantidadDocumentosOse = Tbl.SumaCantidadDocumentos							--Lo Obtiene del detalleconsumo
											,@GeneradoOse = Tbl.Generado														--Flag que indicara si esta reservado(0) o generado(1)
											,@CantComprobantesEmitidosOse = Tbl.CantComprobantesEmitidos						--Obtiene la cantidad de facturas del contrato que se hayan emitido en el mes
									FROM @TbIncluirOse Tbl
									INNER JOIN Maestro.TipoComprobante tipCom ON Tbl.IdTipoComprobante = tipCom.IdTipoComprobante
									INNER JOIN Maestro.TipoCambio tipCam ON tbl.IdTipoCambio = tipCam.IdTipoCambio
								END
								
								/***********************************************************************************************************************************
								Obtiene los subtotales
								***********************************************************************************************************************************/
								IF @IdMonedaPse = 1 --SOLES
								BEGIN
									SET @CompDetPseMontoSoles = @SubtotalPse + @CargoBasicoPse
									SET @CompDetPseMontoExcedenteSoles = @MontoExcedenteFinalPse
									SET @CompDetPseMontoDolares = (@SubtotalPse + @CargoBasicoPse) / @TipoCambio
									SET @CompDetPseMontoExcedenteDolares = @MontoExcedenteFinalPse / @TipoCambio

									SET @CompDetOseMontoSoles = @SubtotalOse + @CargoBasicoOse
									SET @CompDetOseMontoExcedenteSoles = @MontoExcedenteFinalOse
									SET @CompDetOseMontoDolares = (@SubtotalOse + @CargoBasicoOse) / @TipoCambio
									SET @CompDetOseMontoExcedenteDolares = @MontoExcedenteFinalOse / @TipoCambio
								END;

								IF @IdMonedaPse = 2 --DOLARES
								BEGIN
									SET @CompDetPseMontoSoles = (@SubtotalPse + @CargoBasicoPse) * @TipoCambio
									SET @CompDetPseMontoExcedenteSoles = @MontoExcedenteFinalPse * @TipoCambio
									SET @CompDetPseMontoDolares = @SubtotalPse + @CargoBasicoPse
									SET @CompDetPseMontoExcedenteDolares = @MontoExcedenteFinalPse

									SET @CompDetOseMontoSoles = (@SubtotalOse + @CargoBasicoOse) * @TipoCambio
									SET @CompDetOseMontoExcedenteSoles = @MontoExcedenteFinalOse * @TipoCambio
									SET @CompDetOseMontoDolares = @SubtotalOse + @CargoBasicoOse
									SET @CompDetOseMontoExcedenteDolares = @MontoExcedenteFinalOse
								END;


								--********* BLOQUE GENERAL
								SET @FechaMesParametro = NULL
								SET @FechaMesSiguienteAlParametro = NULL --Hallar mes y año proximo a la fecha de parametro; por ejemplo si el mes de proceso es enero, entonces este valor sera febrero
								SET @FechaMesSiguienteAlParametro = CONVERT(DATETIME, '01/' + @MesGeneracion + '/' + @AnioGeneracion, 103)
								SET @FechaMesSiguienteAlParametro = DATEADD(D, 35, @FechaMesSiguienteAlParametro)
								--Si el ultimo parametro es 1: devuelve la fecha del ultimo dia del mes @MesGeneracion excepto domingo; por ejemplo:
								--si ingresas mes:12  año:2017  mesanterior:1  entonces retorna 30/12/2017 debido a que 31/12/2017 es domingo
								--antes de invocar la funcion se debe setear 'set firstdate 1' para que el lunes sea dia 1
								SET @FechaMesParametro = dbo.FechaMesAnterior(@MesGeneracion, @AnioGeneracion, 1)


								--********* BLOQUE PSE
								
								SET @MensajeCantidadDocumentosPse = ''
								SET @DescripcionItem1_MesSiguientePse = ''
								SET @DescripcionItem2_MesParametroPse = ''
								SET @DescripcionItem3_MesParametroPse = ''
								
								SET @MensajeCantidadDocumentosPse = '; Cantidad de documentos: ' + REPLACE(CONVERT(VARCHAR, CAST(@SumaCantidadDocumentosPse AS MONEY), 1), '.00', '')
								SET @DescripcionItem1_MesSiguientePse = 'Servicio Mensual : ' + DATENAME(MONTH, @FechaMesSiguienteAlParametro) + ' - ' + DATENAME(YEAR, @FechaMesSiguienteAlParametro)
								SET @DescripcionItem2_MesParametroPse = 'Saldo ' + DATENAME(MONTH, @FechaMesParametro) + ' - ' + DATENAME(YEAR, @FechaMesParametro) + @MensajeCantidadDocumentosPse
								SET @DescripcionItem3_MesParametroPse = 'Servicio Mensual : ' + DATENAME(MONTH, @FechaMesParametro) + ' - ' + DATENAME(YEAR, @FechaMesParametro) + @MensajeCantidadDocumentosPse
								

								--********* BLOQUE OSE
								
								SET @MensajeCantidadDocumentosOse = ''
								SET @DescripcionItem1_MesSiguienteOse = ''
								SET @DescripcionItem2_MesParametroOse = ''
								SET @DescripcionItem3_MesParametroOse = ''
								
								IF (SELECT COUNT(ose.IdContratoOse) FROM @TbIncluirOse ose) > 0
								BEGIN
									SET @MensajeCantidadDocumentosOse = '; Cantidad de documentos: ' + REPLACE(CONVERT(VARCHAR, CAST(@SumaCantidadDocumentosOse AS MONEY), 1), '.00', '')
									SET @DescripcionItem1_MesSiguienteOse = 'Servicio Ose Mensual : ' + DATENAME(MONTH, @FechaMesSiguienteAlParametro) + ' - ' + DATENAME(YEAR, @FechaMesSiguienteAlParametro)
									SET @DescripcionItem2_MesParametroOse = 'Saldo ' + DATENAME(MONTH, @FechaMesParametro) + ' - ' + DATENAME(YEAR, @FechaMesParametro) + @MensajeCantidadDocumentosOse
									SET @DescripcionItem3_MesParametroOse = 'Servicio Mensual : ' + DATENAME(MONTH, @FechaMesParametro) + ' - ' + DATENAME(YEAR, @FechaMesParametro) + @MensajeCantidadDocumentosOse
								END


								/***********************************************************************************************************************************
								VALIDACION DE LOS CASOS QUE PUEDE TOMAR EL CONTRATO
								---------------------------------------------------
								- @FacturaPorAdelantado = 1 ^ AND @FacturaMesAnterior = 0 SE CREAN 2 ITEMS, PERO SI EL MONTO EXCEDENTE FINAL DE @TbPreviasPse ES 0, ENTONCES NO SE CREA EL SEGUNDO ITEM
								- @FacturaPorAdelantado = 0 ^ AND @FacturaMesAnterior = 1 SOLO SE CREA UN ITEM
								- @FacturaPorAdelantado = 0 ^ AND @FacturaMesAnterior = 0 SOLO SE CREA UN ITEM
								- @FacturaPorAdelantado = 1 ^ AND @FacturaMesAnterior = 1 ESTE CASO NUNCA SE PUEDE DAR X
								***********************************************************************************************************************************/
								DELETE FROM @DetalleComprobante;

								IF @FacturaPorAdelantadoPse = 1 AND @FacturaMesAnteriorPse = 0
								BEGIN

									SET @Numeracion2doItemPorAdelantado = 1
									--CREARA 2 ITEMS PSE EN COMPROBANTE
									--CREARA 2 ITEMS OSE EN COMPROBANTE
									INSERT INTO @DetalleComprobante VALUES(
										@Numeracion2doItemPorAdelantado
										,@IdComprobante
										,@IdServicioPse
										,@IdTarifaPse
										,@DescripcionItem1_MesSiguientePse
										,@CuentaContablePse
										,CAST(ROUND(@CompDetPseMontoSoles, 2) AS DECIMAL(9, 2))
										,CAST(ROUND(@CompDetPseMontoSoles, 2) AS DECIMAL(9, 2))
										,CAST(ROUND(@CompDetPseMontoDolares, 2) AS DECIMAL(9, 2))
										,CAST(ROUND(@CompDetPseMontoDolares, 2) AS DECIMAL(9, 2))
										);

										SET @Numeracion2doItemPorAdelantado = @Numeracion2doItemPorAdelantado + 1 --para el siguiente item sera 2

									IF @CompDetPseMontoExcedenteSoles > 0 AND @CompDetPseMontoExcedenteDolares > 0 --EVALUA SI SE GENERARA EL SEGUNDO ITEM SI ES QUE EL MONTO ES MAYOR A CERO
									BEGIN
										
										INSERT INTO @DetalleComprobante VALUES(
											@Numeracion2doItemPorAdelantado
											,@IdComprobante
											,@IdServicioPse
											,@IdTarifaPse
											,@DescripcionItem2_MesParametroPse
											,@CuentaContablePse
											,CAST(ROUND(@CompDetPseMontoExcedenteSoles, 2) AS DECIMAL(9, 2))
											,CAST(ROUND(@CompDetPseMontoExcedenteSoles, 2) AS DECIMAL(9, 2))
											,CAST(ROUND(@CompDetPseMontoExcedenteDolares, 2) AS DECIMAL(9, 2))
											,CAST(ROUND(@CompDetPseMontoExcedenteDolares, 2) AS DECIMAL(9, 2))
											);

											SET @Numeracion2doItemPorAdelantado = @Numeracion2doItemPorAdelantado + 1 --se coloca 3

									END

									IF (SELECT COUNT(IdContratoOse) FROM @TbIncluirOse) > 0
									BEGIN
										INSERT INTO @DetalleComprobante VALUES(
											@Numeracion2doItemPorAdelantado --SE DEBE VALIDAR SI SERA 3 ó 2
											,@IdComprobante
											,@IdServicioOse
											,@IdTarifaOse
											,@DescripcionItem1_MesSiguienteOse
											,@CuentaContableOse
											,CAST(ROUND(@CompDetOseMontoSoles, 2) AS DECIMAL(9, 2))
											,CAST(ROUND(@CompDetOseMontoSoles, 2) AS DECIMAL(9, 2))
											,CAST(ROUND(@CompDetOseMontoDolares, 2) AS DECIMAL(9, 2))
											,CAST(ROUND(@CompDetOseMontoDolares, 2) AS DECIMAL(9, 2))
											);

											SET @Numeracion2doItemPorAdelantado = @Numeracion2doItemPorAdelantado + 1 

											IF @CompDetOseMontoExcedenteSoles > 0 AND @CompDetOseMontoExcedenteDolares > 0 --EVALUA SI SE GENERARA EL SEGUNDO ITEM SI ES QUE EL MONTO ES MAYOR A CERO
											BEGIN
										
												INSERT INTO @DetalleComprobante VALUES(
													@Numeracion2doItemPorAdelantado
													,@IdComprobante
													,@IdServicioOse
													,@IdTarifaOse
													,@DescripcionItem2_MesParametroOse
													,@CuentaContableOse
													,CAST(ROUND(@CompDetOseMontoExcedenteSoles, 2) AS DECIMAL(9, 2))
													,CAST(ROUND(@CompDetOseMontoExcedenteSoles, 2) AS DECIMAL(9, 2))
													,CAST(ROUND(@CompDetOseMontoExcedenteDolares, 2) AS DECIMAL(9, 2))
													,CAST(ROUND(@CompDetOseMontoExcedenteDolares, 2) AS DECIMAL(9, 2))
													);
											END
									END
								END
								ELSE
								BEGIN
									IF @FacturaPorAdelantadoPse = 0 AND @FacturaMesAnteriorPse = 1
									BEGIN
											--CREARA SOLO 1 ITEM PSE EN COMPROBANTE
											--CREARA SOLO 1 ITEM OSE EN COMPROBANTE
											INSERT INTO @DetalleComprobante VALUES(
												1
												,@IdComprobante
												,@IdServicioPse
												,@IdTarifaPse
												,@DescripcionItem3_MesParametroPse
												,@CuentaContablePse
												,CAST(ROUND((@CompDetPseMontoSoles + @CompDetPseMontoExcedenteSoles), 2) AS DECIMAL(9, 2))
												,CAST(ROUND((@CompDetPseMontoSoles + @CompDetPseMontoExcedenteSoles), 2) AS DECIMAL(9, 2))
												,CAST(ROUND((@CompDetPseMontoDolares + @CompDetPseMontoExcedenteDolares), 2) AS DECIMAL(9, 2))
												,CAST(ROUND((@CompDetPseMontoDolares + @CompDetPseMontoExcedenteDolares), 2) AS DECIMAL(9, 2))
												);
											--DEBO VALIDAR QUE EXISTA OSE
											IF (SELECT COUNT(IdContratoOse) FROM @TbIncluirOse) > 0
											BEGIN
												INSERT INTO @DetalleComprobante VALUES(
													2
													,@IdComprobante
													,@IdServicioOse
													,@IdTarifaOse
													,@DescripcionItem3_MesParametroOse
													,@CuentaContableOse
													,CAST(ROUND((@CompDetOseMontoSoles +   @CompDetOseMontoExcedenteSoles), 2) AS DECIMAL(9, 2))
													,CAST(ROUND((@CompDetOseMontoSoles +   @CompDetOseMontoExcedenteSoles), 2) AS DECIMAL(9, 2))
													,CAST(ROUND((@CompDetOseMontoDolares + @CompDetOseMontoExcedenteDolares), 2) AS DECIMAL(9, 2))
													,CAST(ROUND((@CompDetOseMontoDolares + @CompDetOseMontoExcedenteDolares), 2) AS DECIMAL(9, 2))
													);
											END
									END
									ELSE --IF @FacturaPorAdelantado = 0 AND @FacturaMesAnterior = 0
									BEGIN
										--CREARA SOLO 1 ITEM PSE EN COMPROBANTE
										--CREARA SOLO 1 ITEM OSE EN COMPROBANTE
										INSERT INTO @DetalleComprobante VALUES(
											1
											,@IdComprobante
											,@IdServicioPse
											,@IdTarifaPse
											,@DescripcionItem1_MesSiguientePse + @MensajeCantidadDocumentosPse
											,@CuentaContablePse
											,CAST(ROUND((@CompDetPseMontoSoles +	@CompDetPseMontoExcedenteSoles), 2) AS DECIMAL(9, 2))
											,CAST(ROUND((@CompDetPseMontoSoles +	@CompDetPseMontoExcedenteSoles), 2) AS DECIMAL(9, 2))
											,CAST(ROUND((@CompDetPseMontoDolares +	@CompDetPseMontoExcedenteDolares), 2) AS DECIMAL(9, 2))
											,CAST(ROUND((@CompDetPseMontoDolares +	@CompDetPseMontoExcedenteDolares), 2) AS DECIMAL(9, 2))
											);

										--DEBO VALIDAR QUE EXISTA OSE
										IF (SELECT COUNT(IdContratoOse) FROM @TbIncluirOse) > 0
										BEGIN
											INSERT INTO @DetalleComprobante VALUES(
												2
												,@IdComprobante
												,@IdServicioOse
												,@IdTarifaOse
												,@DescripcionItem1_MesSiguienteOse + @MensajeCantidadDocumentosOse
												,@CuentaContableOse
												,CAST(ROUND((@CompDetOseMontoSoles +	@CompDetOseMontoExcedenteSoles), 2) AS DECIMAL(9, 2))
												,CAST(ROUND((@CompDetOseMontoSoles +	@CompDetOseMontoExcedenteSoles), 2) AS DECIMAL(9, 2))
												,CAST(ROUND((@CompDetOseMontoDolares +	@CompDetOseMontoExcedenteDolares), 2) AS DECIMAL(9, 2))
												,CAST(ROUND((@CompDetOseMontoDolares +	@CompDetOseMontoExcedenteDolares), 2) AS DECIMAL(9, 2))
												);	
										END
									
									END

								END

								EXEC Facturacion.usp_Comprobante_ins_Automatica_eFacturacion_test4 @Accion, @IdClientePse, @DetalleComprobante;

								/***********************************************************************************************************************************
								Procesar totales del comprobante
								***********************************************************************************************************************************/
								SET @EsDescuento = (
										SELECT ISNULL(EsDescuento, 0)
										FROM Maestro.Tarifa
										WHERE IdTarifa = @IdTarifaPse
										);

								IF @EsDescuento = 0
								BEGIN
									SET @PorcDetraccion = (
											SELECT ISNULL(PORCDETRACCION, 0)
											FROM Maestro.Tarifa
											WHERE IdTarifa = @IdTarifaPse
												AND EsDescuento = 0
											)
								END

								EXEC FACTURACION.USP_COMPROBANTE_UPD_TOTALES @IdComprobante, @TasaIgvPse, @PorcDetraccion;
								SET @CantidadProcesados = @CantidadProcesados + 1

								/***********************************************************************************************************************************
								Procesar comisiones
								***********************************************************************************************************************************/
								EXEC FACTURACION.USP_COMPROBANTECOMISION_CALCULAR @IdComprobante;

								/***********************************************************************************************************************************
								ACTUALIZA NUMERO DE DOCUMENTO ACTUAL PARA EL SIGUIENTE CONTRATO
								***********************************************************************************************************************************/
								IF @Accion = 'new'
								BEGIN
									UPDATE Maestro.TipoComprobante SET NumeroActual = @NroComprobante WHERE IdTipoComprobante = @ConstIdTipoComprobante	AND Serie = @Serie;
								END

								/***********************************************************************************************************************************
								ACTUALIZAR PROCESADO EN LA TABLA DETALLECONSUMO PSE
								***********************************************************************************************************************************/
								DELETE FROM @Temp_IdDetalleConsumoeFacturacion;
								SET @IdDetalleConsumoCantidad = 0;

								INSERT INTO @Temp_IdDetalleConsumoeFacturacion
								SELECT DETCON.IdDetalleConsumoeFacturacion
								FROM Facturacion.DetalleConsumoeFacturacion DETCON
								WHERE IdDetalleConsumoeFacturacion IN (
										SELECT TB2.IdDetalleConsumoeFacturacion
										FROM @TbContratosVsConsumosPse TB2
										WHERE TB2.IdContratoeFacturacion = @IdContratoeFacturacion
										)
									AND ISNULL(DETCON.Procesado, 0) = 0;

								SELECT @IdDetalleConsumoCantidad = COUNT(IdDetalleConsumo) FROM @Temp_IdDetalleConsumoeFacturacion;

								IF @IdDetalleConsumoCantidad IS NOT NULL
								BEGIN
									IF @IdDetalleConsumoCantidad > 0
									BEGIN
										SET @Temp_Log = ' * ACTUALIZA EL ESTADO EN LA TABLA Facturacion.DetalleConsumoeFacturacion, PROCESADO Y FECHA DE PROCESO' + '|| ||'
										SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log

										PRINT @Temp_Log

										UPDATE Facturacion.DetalleConsumoeFacturacion
										SET Procesado = 1
											,FechaProceso = GETDATE()
										WHERE IdDetalleConsumoeFacturacion IN (
												SELECT IdDetalleConsumo
												FROM @Temp_IdDetalleConsumoeFacturacion
												)
									END

								END

								/***********************************************************************************************************************************
								ACTUALIZAR PROCESADO EN LA TABLA DETALLECONSUMO OSE
								***********************************************************************************************************************************/
								DELETE FROM @Temp_IdDetalleConsumoeFacturacion;
								SET @IdDetalleConsumoCantidad = 0;

								INSERT INTO @Temp_IdDetalleConsumoeFacturacion
								SELECT DETCON.IdDetalleConsumoeFacturacionOse
								FROM Facturacion.DetalleConsumoeFacturacionOse DETCON
								WHERE IdDetalleConsumoeFacturacionOse IN (
										SELECT TB2.IdConsumo
										FROM @TbContratosVsConsumosOse TB2
										WHERE TB2.IdContrato = @IdContratoOse
										)
									AND ISNULL(DETCON.Procesado, 0) = 0;

								SELECT @IdDetalleConsumoCantidad = COUNT(IdDetalleConsumo) FROM @Temp_IdDetalleConsumoeFacturacion;

								IF @IdDetalleConsumoCantidad IS NOT NULL
								BEGIN
									IF @IdDetalleConsumoCantidad > 0
									BEGIN
										SET @Temp_Log = ' * ACTUALIZA EL ESTADO EN LA TABLA Facturacion.DetalleConsumoeFacturacion OSE, PROCESADO Y FECHA DE PROCESO' + '|| ||'
										SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log

										PRINT @Temp_Log

										UPDATE Facturacion.DetalleConsumoeFacturacionOse
										SET Procesado = 1
											,FechaProceso = GETDATE()
										WHERE IdDetalleConsumoeFacturacionOse IN (
												SELECT IdDetalleConsumo
												FROM @Temp_IdDetalleConsumoeFacturacion
												)
									END

								END
								/***********************************************************************************************************************************
								***********************************************************************************************************************************/
																
								--INSERTAR EL LOG

								INSERT INTO @TempTablaComprobantesInsertados
								VALUES(@IdComprobante, (@Serie + '-' + @NroComprobante), @IdContratoeFacturacion, @IdContratoOse, @Temp_LogInsertado)

								--UPDATE @TempTablaComprobantesInsertados
								--SET LogInsertado = @Temp_LogInsertado
								--WHERE IdComprobanteInsertado = @IdComprobante

							END --FIN IF IDCOMPROBANTE>0
						END --FIN IF IDCOMPROBANTE IS NOT NULL

					END --FINALIZACION  DE LA VALIDACION DE FACTURAMESANTERIOR Y FACTURAPORADELANTADO

				END --FIN IF @EMITIR>0

			END

			--COMMIT TRAN
		--END TRY

		--BEGIN CATCH
		--	ROLLBACK TRANSACTION
		--END CATCH

		SET @ContadorPse = @ContadorPse + 1;
	END;--END WHILE PSE


	SET @ContadorOse = 1
	WHILE @ContadorOse <= @TotalFilasOse
	BEGIN

		SET @Temp_Log = ''
		SET @Temp_LogInsertado = ''
		SET @MesCorrelativoComprobante = ''
		SET @AnioCorrelativoComprobante = ''
		SET @Accion = 'new'
		SET @Emitir = 0
		SET @PorcDetraccion = 0

		/***********************************************************************************************************************************
		OBTIENE LOS DATOS FILA X FILA DEL PARAMETRO @TbPreviaPse
		***********************************************************************************************************************************/
		SELECT	@Serie = tipCom.Serie
				,@NroComprobanteActual = (CAST(ISNULL(tipCom.NumeroActual, 0) AS INT) + 1)			--Toma el ultimo numero actual de la tabla TipoComprobante y le agrega 1
				,@IdContratoOse = Tbl.IdContratoOse
				,@CargoBasicoOse = Tbl.CargoBasico
				,@SubtotalOse = Tbl.Subtotal
				,@MontoExcedenteFinalOse = Tbl.MontoExcedenteFinal
				,@FacturaPorAdelantadoOse = Tbl.FacturaPorAdelantado								--Flag
				,@FacturaMesAnteriorOse = Tbl.FacturaMesAnterior									--Flag
				,@FechaGeneradoOse = Tbl.FechaGenerado												--La fecha varia si es de mes anterior o del presente
				,@IdMonedaOse = Tbl.IdMoneda														--1	Nuevo Sol ; 2 Dolar                                                                        
				,@IdClienteOse = Tbl.IdCliente
				,@PlazoDiasOse = Tbl.PlazoDias
				,@IdAsesorComercialOse = Tbl.IdAsesorComercial
				,@IdServicioOse = Tbl.IdServicio
				,@IdTarifaOse = Tbl.IdTarifa
				,@CuentaContableOse = Tbl.CuentaContable
				,@IdTipoCambioOse = Tbl.IdTipoCambio
				,@TipoCambio = tipCam.TipoCambio
				,@CuentaIgvOse = Tbl.CuentaIgv
				,@TasaIgvOse = CAST(ROUND(Tbl.TasaIgv, 2) AS DECIMAL(9, 2))							--Porcentaje Igv 18.00 %
				,@CuentaComprobanteMonedaOse = Tbl.CuentaComprobanteMoneda
				,@SumaCantidadDocumentosOse = Tbl.SumaCantidadDocumentos							--Lo Obtiene del detalleconsumo
				,@GeneradoOse = Tbl.Generado														--Flag que indicara si esta reservado(0) o generado(1)
				,@CantComprobantesEmitidosOse = Tbl.CantComprobantesEmitidos						--Obtiene la cantidad de facturas del contrato que se hayan emitido en el mes
				,@IdContactoOse = Tbl.IdContacto
				,@IdContratoeFacturacionGeneralOse = Tbl.IdContratoeFacturacionGeneral
		FROM @TbPreviaOseSinPse Tbl
		INNER JOIN Maestro.TipoComprobante tipCom ON Tbl.IdTipoComprobante = tipCom.IdTipoComprobante
		INNER JOIN Maestro.TipoCambio tipCam ON tbl.IdTipoCambio = tipCam.IdTipoCambio
		WHERE Tbl.Item = @ContadorOse;

		/***********************************************************************************************************************************
		PROCESO
			
		SI GENERADOPSE ES '1', ENTONCES YA ESTA GENERADO EL COMPROBANTE DEL CONTRATO
		SI GENERADOPSE ES '0', ENTONCES SE VALIDA @CantComprobantesEmitidos, EN CASO SEA MAYOR A 1 SE DEBERA MODIFICAR EL COMPROBANTE
							PERO SI @CantComprobantesEmitidos ES CERO ENTONCES SE CREARA UN NUEVO COMPROBANTE
		@SumaCantidadDocumentosPse = catnidad de facturas transmitidas + boketas + nc + nd + etc... del detalle consumo e facturacion
		***********************************************************************************************************************************/
		IF @GeneradoOse = '1'
		BEGIN

			SET @Temp_Log = '||EL CONTRATO CON ID ' + CAST(@IdContratoOse AS VARCHAR) + ' YA TIENE COMPROBANTE GENERADO ||';
			SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log
			PRINT @Temp_Log

		END
		ELSE --IF @GeneradoOse = '0'
		BEGIN
			
			/***********************************************************************************************************************************
			Valida si @Accion sera actualizar(upd) o nuevo(new)
			- Si @CantComprobantesEmitidos > 0, significa que en la tabla [Facturacion].[ContratoControleFacturacion] ya existe registrado el contrato contra un comprobante
			- @FechaGenerado puede ser del mes-año anterior o actual
			- Si @Emitir es 0, entonces, en sus detallesconsumo ya figuran como procesados y es que en el parametro @TbContratosVsConsumosPse no existen registros(casillas) del contrato	
			- Si @Emitir es 1, entonces debe emitir un comprobante
			***********************************************************************************************************************************/
			SET @Accion = CASE WHEN (@CantComprobantesEmitidosOse > 0) THEN 'upd' ELSE 'new' END;
			SET @MesCorrelativoComprobante = RIGHT('00' + CAST(MONTH(@FechaGeneradoOse) AS VARCHAR(2)), 2)		
			SET @AnioCorrelativoComprobante = RIGHT('0000' + CAST(YEAR(@FechaGeneradoOse) AS VARCHAR(4)), 4)	

			--La cantidad de registros del detalle consumo por contrato; pero que no hayan sido procesados
			--Si emitir = 0, no tiene trafico consumo ó todos sus detalles consumos ya fueron procesados
			SELECT @Emitir = COUNT(detCon.IdDetalleConsumoeFacturacionOse)
			FROM Facturacion.DetalleConsumoeFacturacionOse detCon
			WHERE detCon.IdDetalleConsumoeFacturacionOse IN (SELECT TB2.IdConsumo
															FROM @TbContratosVsConsumosOse TB2 
															WHERE TB2.IdContrato = @IdContratoOse)
					AND ISNULL(detCon.Procesado, 0) = 0;

			/***********************************************************************************************************************************
			Se actualiza los contratos que ya tengan comprobante
			***********************************************************************************************************************************/
			IF @CantComprobantesEmitidosOse > 0 AND @GeneradoOse = '0' AND @Accion = 'upd'
			BEGIN					
				SET @Emitir = 1
			END

			/***********************************************************************************************************************************
			- Validando si es un contrato activo que no tenga consumo; solo se facturara cargo basico mas monto minimo
			- Si emitir es 0 (si sigue siendo cero no se generara comprobante) y en @TbContratosVsConsumosPse no existe registro de IdDetalleConsumo
			***********************************************************************************************************************************/
			IF @Emitir = 0 AND ((SELECT TOP 1 TB2.IdConsumo 
									FROM @TbContratosVsConsumosOse TB2 
									WHERE TB2.IdContrato = @IdContratoOse) = 0)
			BEGIN
				IF @CantComprobantesEmitidosOse = 0 --en caso no tenga detalle o cantidad de trafico en detalle consumo
				BEGIN
					SET @Temp_Log = '||EL CONTRATO CON ID ' + CAST(@IdContratoOse AS VARCHAR) + ' NO POSEE CONSUMO PERO SE EMITIRA CON EL MONTO MINIMO||';
					SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log

					PRINT @Temp_Log

					SET @Emitir = 1
					--SI @Emitir = 1, ENTONCES SE PROCEDERA A EFECTUAR EL COMPROBANTE
				END
			END

			/***********************************************************************************************************************************
			Algunas empresas tendran mas de un contrato (habra consumo por parte de la entidad); 
			Pero el primer contrato tomara la casilla con su consumo y emitira su comprobante; el segundo contrato debera efectuar
			un comprobante a pesar de que el flag de la empresa en detalle consumo esta en 1 (procesado); este monto sera 
			el cargo basico + el monto minimo
			La validacion general es 'emitir = 0 y tiene DetalleConsumo'
			***********************************************************************************************************************************/
			IF @Emitir = 0 AND ((SELECT TOP 1 TB2.IdConsumo 
									FROM @TbContratosVsConsumosOse TB2 
									WHERE TB2.IdContrato = @IdContratoOse) != 0)
			BEGIN
				IF @CantComprobantesEmitidosOse = 0 --es un campo de la variable estructural @TbContratosVsConsumosPse
				BEGIN
					SET @Temp_Log = '||LA EMPRESA CON EL CONTRATO ID ' + CAST(@IdContratoOse AS VARCHAR) + ' SI POSEE CONSUMO PERO SE DOCUMENTO EN UN COMPROBANTE CON OTRO CONTRATO';
					SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log

					PRINT @Temp_Log

					SET @Emitir = 1
					--SI NO EXISTE CONSUMO, ENTONCES NO HAY DOCUMENTOS NI MONTO EXCESO
					SET @SumaCantidadDocumentosOse = 0
					SET @MontoExcedenteFinalOse = 0
						--SI @Emitir = 1, ENTONCES SE PROCEDERA A EFECTUAR EL COMPROBANTE
				END
			END


			/***********************************************************************************************************************************
			Solo si @Emitir es 1 se generan los comprobantes
			***********************************************************************************************************************************/
			IF @Emitir > 0
			BEGIN
										
				PRINT CHAR(13) + CHAR(10) + 'EVALUANDO QUE NO ESTEN LOS CHECK DE FACTURARMESANTERIOR Y FACTURARPORADELANTADO MARCADOS A LA VEZ'

				IF @FacturaMesAnteriorOse = 1 AND @FacturaPorAdelantadoOse = 1
				BEGIN
					PRINT 'FACTURARMESANTERIOR Y FACTURARPORADELANTADO NO PUEDEN ESTAR MARCADOS A LA VEZ; ' + CAST(@ContadorOse AS VARCHAR);
				END
				ELSE
				BEGIN
					SET @Temp_Log = '||REGISTRANDO COMPROBANTE N°' + CAST(@ContadorOse AS VARCHAR) + '||';
					SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log

					PRINT @Temp_Log

					/***********************************************************************************************************************************
					PROCESAR CABECERA DEL COMPROBANTE
					***********************************************************************************************************************************/
					SET @IdComprobante = NULL
					IF @Accion = 'new' --genera nuevo numero de comprobante
					BEGIN
						SET @NroComprobante = (RIGHT('00000000' + CAST(@NroComprobanteActual AS VARCHAR), 8))
						SET @MvtoCorrelativoActual = (
								SELECT (CAST(ISNULL(MAX(MovimientoCorrelativo), 0) AS INT) + 1)
								FROM Facturacion.Comprobante
								WHERE NroMovimientoxMes = @MesCorrelativoComprobante AND NroMovimientoxAnio = @AnioCorrelativoComprobante
								)
						SET @MvtoCorrelativo = (RIGHT('0000' + CAST(@MvtoCorrelativoActual AS VARCHAR), 4))
							
						SET @IdComprobante = (SELECT (MAX(ISNULL(IdComprobante, 0)) + 1) FROM Facturacion.Comprobante);
					END

					IF @Accion = 'upd'
					BEGIN
						--IdAsesorComercial = @IdAsesorComercial
						--IdComprobante = @IdComprobante

						SET @IdComprobante = (SELECT IdComprobante FROM Facturacion.Comprobante 
						WHERE MesFacturacion = @ConstMesGeneracion AND 
						AnioFacturacion = @ConstAnioGeneracion AND
						IdContratoOse = @IdContratoOse AND
						IdEstado = 7)

					END

					IF @IdComprobante IS NOT NULL --SI ES NUEVO-SACA EL MAXIMO Y LE AGREGA + 1; SI ES MODIFICAR-MEDIANTE UN SELECT DEL CONTRATO SE OBTIENE EL ID
					BEGIN
							
						IF @IdComprobante > 0
						BEGIN
							
							--La accion determina new o upd
							EXEC [Facturacion].[usp_Comprobante_ins_Automatica_eFacturacion_test3]
								@Accion							--es el mismo tanto para PSE como para OSE
								,@IdComprobante					--es el mismo tanto para PSE como para OSE
								,@AnioCorrelativoComprobante	--es el mismo tanto para PSE como para OSE
								,@MesCorrelativoComprobante		--es el mismo tanto para PSE como para OSE
								,@MvtoCorrelativo				--es el mismo tanto para PSE como para OSE
								,@CuentaComprobanteMonedaOse	--es el mismo tanto para PSE como para OSE
								,@FechaGeneradoOse				--es el mismo tanto para PSE como para OSE
								,@IdClienteOse					--es el mismo tanto para PSE como para OSE
								,@IdMonedaOse					--es el mismo tanto para PSE como para OSE
								,@Serie							--es el mismo tanto para PSE como para OSE
								,@NroComprobante				--es el mismo tanto para PSE como para OSE
								,@CuentaIgvOse					--es el mismo tanto para PSE como para OSE
								,@TasaIgvOse					--es el mismo tanto para PSE como para OSE
								,@IdTipoCambioOse				--es el mismo tanto para PSE como para OSE
								,@PlazoDiasOse					--es el mismo tanto para PSE como para OSE
								,NULL --@IdContratoeFacturacion
								,@IdAsesorComercialOse			--es el mismo tanto para PSE como para OSE
								,@ConstMesGeneracion			--es el mismo tanto para PSE como para OSE
								,@ConstAnioGeneracion			--es el mismo tanto para PSE como para OSE
								,@ConstEsReservado				--es el mismo tanto para PSE como para OSE
								,@IdContactoOse 
								,@IdContratoOse

							EXEC Facturacion.usp_Comprobante_upd_DireccionEntrega @IdComprobante;

							/***********************************************************************************************************************************
							PROCESAR DETALLE DEL COMPROBANTE
							***********************************************************************************************************************************/
							IF @IdMonedaOse = 1 --SOLES
							BEGIN
								SET @CompDetOseMontoSoles = @SubtotalOse + @CargoBasicoOse
								SET @CompDetOseMontoExcedenteSoles = @MontoExcedenteFinalOse
								SET @CompDetOseMontoDolares = (@SubtotalOse + @CargoBasicoOse) / @TipoCambio
								SET @CompDetOseMontoExcedenteDolares = @MontoExcedenteFinalOse / @TipoCambio
							END;

							IF @IdMonedaOse = 2 --DOLARES
							BEGIN
								SET @CompDetOseMontoSoles = (@SubtotalOse + @CargoBasicoOse) * @TipoCambio
								SET @CompDetOseMontoExcedenteSoles = @MontoExcedenteFinalOse * @TipoCambio
								SET @CompDetOseMontoDolares = @SubtotalOse + @CargoBasicoOse
								SET @CompDetOseMontoExcedenteDolares = @MontoExcedenteFinalOse
							END;


							--********* BLOQUE GENERAL
							SET @FechaMesParametro = NULL
							SET @FechaMesSiguienteAlParametro = NULL --Hallar mes y año proximo a la fecha de parametro; por ejemplo si el mes de proceso es enero, entonces este valor sera febrero
							SET @FechaMesSiguienteAlParametro = CONVERT(DATETIME, '01/' + @MesGeneracion + '/' + @AnioGeneracion, 103)
							SET @FechaMesSiguienteAlParametro = DATEADD(D, 35, @FechaMesSiguienteAlParametro)
							--Si el ultimo parametro es 1: devuelve la fecha del ultimo dia del mes @MesGeneracion excepto domingo; por ejemplo:
							--si ingresas mes:12  año:2017  mesanterior:1  entonces retorna 30/12/2017 debido a que 31/12/2017 es domingo
							--antes de invocar la funcion se debe setear 'set firstdate 1' para que el lunes sea dia 1
							SET @FechaMesParametro = dbo.FechaMesAnterior(@MesGeneracion, @AnioGeneracion, 1)


							--********* BLOQUE OSE
							SET @MensajeCantidadDocumentosOse = ''
							SET @DescripcionItem1_MesSiguienteOse = ''
							SET @DescripcionItem2_MesParametroOse = ''
							SET @DescripcionItem3_MesParametroOse = ''
								
							--IF (SELECT COUNT(ose.IdContratoOse) FROM @TbIncluirOse ose) > 0
							--BEGIN
								SET @MensajeCantidadDocumentosOse = '; Cantidad de documentos: ' + REPLACE(CONVERT(VARCHAR, CAST(@SumaCantidadDocumentosOse AS MONEY), 1), '.00', '')
								SET @DescripcionItem1_MesSiguienteOse = 'Servicio Ose Mensual : ' + DATENAME(MONTH, @FechaMesSiguienteAlParametro) + ' - ' + DATENAME(YEAR, @FechaMesSiguienteAlParametro)
								SET @DescripcionItem2_MesParametroOse = 'Saldo ' + DATENAME(MONTH, @FechaMesParametro) + ' - ' + DATENAME(YEAR, @FechaMesParametro) + @MensajeCantidadDocumentosOse
								SET @DescripcionItem3_MesParametroOse = 'Servicio Mensual : ' + DATENAME(MONTH, @FechaMesParametro) + ' - ' + DATENAME(YEAR, @FechaMesParametro) + @MensajeCantidadDocumentosOse
							--END


							/***********************************************************************************************************************************
							VALIDACION DE LOS CASOS QUE PUEDE TOMAR EL CONTRATO
							---------------------------------------------------
							- @FacturaPorAdelantado = 1 ^ AND @FacturaMesAnterior = 0 SE CREAN 2 ITEMS, PERO SI EL MONTO EXCEDENTE FINAL DE @TbPreviasPse ES 0, ENTONCES NO SE CREA EL SEGUNDO ITEM
							- @FacturaPorAdelantado = 0 ^ AND @FacturaMesAnterior = 1 SOLO SE CREA UN ITEM
							- @FacturaPorAdelantado = 0 ^ AND @FacturaMesAnterior = 0 SOLO SE CREA UN ITEM
							- @FacturaPorAdelantado = 1 ^ AND @FacturaMesAnterior = 1 ESTE CASO NUNCA SE PUEDE DAR X
							***********************************************************************************************************************************/
							DELETE FROM @DetalleComprobante;
							

							IF @FacturaPorAdelantadoOse = 1 AND @FacturaMesAnteriorOse = 0
							BEGIN
								SET @Numeracion2doItemPorAdelantado = 1
								--CREARA 2 ITEMS PSE EN COMPROBANTE
								--CREARA 2 ITEMS OSE EN COMPROBANTE
								INSERT INTO @DetalleComprobante VALUES(
									@Numeracion2doItemPorAdelantado
									,@IdComprobante
									,@IdServicioOse
									,@IdTarifaOse
									,@DescripcionItem1_MesSiguienteOse
									,@CuentaContableOse
									,CAST(ROUND(@CompDetOseMontoSoles, 2) AS DECIMAL(9, 2))
									,CAST(ROUND(@CompDetOseMontoSoles, 2) AS DECIMAL(9, 2))
									,CAST(ROUND(@CompDetOseMontoDolares, 2) AS DECIMAL(9, 2))
									,CAST(ROUND(@CompDetOseMontoDolares, 2) AS DECIMAL(9, 2))
									);

									SET @Numeracion2doItemPorAdelantado = @Numeracion2doItemPorAdelantado + 1 --para el siguiente item sera 2

								IF @CompDetOseMontoExcedenteSoles > 0 AND @CompDetOseMontoExcedenteDolares > 0 --EVALUA SI SE GENERARA EL SEGUNDO ITEM SI ES QUE EL MONTO ES MAYOR A CERO
								BEGIN
										
									INSERT INTO @DetalleComprobante VALUES(
										@Numeracion2doItemPorAdelantado
										,@IdComprobante
										,@IdServicioOse
										,@IdTarifaOse
										,@DescripcionItem2_MesParametroOse
										,@CuentaContableOse
										,CAST(ROUND(@CompDetOseMontoExcedenteSoles, 2) AS DECIMAL(9, 2))
										,CAST(ROUND(@CompDetOseMontoExcedenteSoles, 2) AS DECIMAL(9, 2))
										,CAST(ROUND(@CompDetOseMontoExcedenteDolares, 2) AS DECIMAL(9, 2))
										,CAST(ROUND(@CompDetOseMontoExcedenteDolares, 2) AS DECIMAL(9, 2))
										);

								END

							END
							ELSE
							BEGIN
								IF @FacturaPorAdelantadoOse = 0 AND @FacturaMesAnteriorOse = 1
								BEGIN
										--CREARA SOLO 1 ITEM PSE EN COMPROBANTE
										--CREARA SOLO 1 ITEM OSE EN COMPROBANTE
										INSERT INTO @DetalleComprobante VALUES(
											1
											,@IdComprobante
											,@IdServicioOse
											,@IdTarifaOse
											,@DescripcionItem3_MesParametroOse
											,@CuentaContableOse
											,CAST(ROUND((@CompDetOseMontoSoles +	@CompDetOseMontoExcedenteSoles), 2) AS DECIMAL(9, 2))
											,CAST(ROUND((@CompDetOseMontoSoles +	@CompDetOseMontoExcedenteSoles), 2) AS DECIMAL(9, 2))
											,CAST(ROUND((@CompDetOseMontoDolares +	@CompDetOseMontoExcedenteDolares), 2) AS DECIMAL(9, 2))
											,CAST(ROUND((@CompDetOseMontoDolares +	@CompDetOseMontoExcedenteDolares), 2) AS DECIMAL(9, 2))
											);

								END
								ELSE --IF @FacturaPorAdelantado = 0 AND @FacturaMesAnterior = 0
								BEGIN
									--CREARA SOLO 1 ITEM PSE EN COMPROBANTE
									--CREARA SOLO 1 ITEM OSE EN COMPROBANTE
									INSERT INTO @DetalleComprobante VALUES(
										1
										,@IdComprobante
										,@IdServicioOse
										,@IdTarifaOse
										,@DescripcionItem1_MesSiguienteOse + @MensajeCantidadDocumentosOse
										,@CuentaContableOse
										,CAST(ROUND((@CompDetOseMontoSoles +	@CompDetOseMontoExcedenteSoles), 2) AS DECIMAL(9, 2))
										,CAST(ROUND((@CompDetOseMontoSoles +	@CompDetOseMontoExcedenteSoles), 2) AS DECIMAL(9, 2))
										,CAST(ROUND((@CompDetOseMontoDolares +	@CompDetOseMontoExcedenteDolares), 2) AS DECIMAL(9, 2))
										,CAST(ROUND((@CompDetOseMontoDolares +	@CompDetOseMontoExcedenteDolares), 2) AS DECIMAL(9, 2))
										);
									
								END

							END

							--en caso que se este modificando el comprobante, se encarga de agregar o quitar el registro respectivo
							EXEC Facturacion.usp_Comprobante_ins_Automatica_eFacturacion_test4 @Accion, @IdClienteOse, @DetalleComprobante;

							/***********************************************************************************************************************************
							Procesar totales del comprobante
							***********************************************************************************************************************************/
							SET @EsDescuento = (
									SELECT ISNULL(EsDescuento, 0)
									FROM Maestro.Tarifa
									WHERE IdTarifa = @IdTarifaOse
									);

							IF @EsDescuento = 0
							BEGIN
								SET @PorcDetraccion = (
										SELECT ISNULL(PorcDetraccion, 0)
										FROM Maestro.Tarifa
										WHERE IdTarifa = @IdTarifaOse
											AND EsDescuento = 0
										)
							END

							EXEC FACTURACION.USP_COMPROBANTE_UPD_TOTALES @IdComprobante, @TasaIgvOse, @PorcDetraccion;
							SET @CantidadProcesados = @CantidadProcesados + 1

							/***********************************************************************************************************************************
							Procesar comisiones
							***********************************************************************************************************************************/
							EXEC FACTURACION.USP_COMPROBANTECOMISION_CALCULAR @IdComprobante;

							/***********************************************************************************************************************************
							ACTUALIZA NUMERO DE DOCUMENTO ACTUAL PARA EL SIGUIENTE CONTRATO
							***********************************************************************************************************************************/
							IF @Accion = 'new'
							BEGIN
								UPDATE Maestro.TipoComprobante SET NumeroActual = @NroComprobante WHERE IdTipoComprobante = @ConstIdTipoComprobante	AND Serie = @Serie;
							END
							--ACTUALIZAR PROCESADO EN LA TABLA DETALLECONSUMO
							DELETE FROM @Temp_IdDetalleConsumoeFacturacion; --limpio la variable
							SET @IdDetalleConsumoCantidad = 0; --limpio la variable

							INSERT INTO @Temp_IdDetalleConsumoeFacturacion
							SELECT DETCON.IdDetalleConsumoeFacturacionOse
							FROM Facturacion.DetalleConsumoeFacturacionOse DETCON
							WHERE IdDetalleConsumoeFacturacionOse IN (
									SELECT TB2.IdConsumo
									FROM @TbContratosVsConsumosOse TB2
									WHERE TB2.IdContrato = @IdContratoOse
									)
								AND ISNULL(DETCON.Procesado, 0) = 0;

							SELECT @IdDetalleConsumoCantidad = COUNT(IdDetalleConsumo) FROM @Temp_IdDetalleConsumoeFacturacion;

							IF @IdDetalleConsumoCantidad IS NOT NULL
							BEGIN
								IF @IdDetalleConsumoCantidad > 0
								BEGIN
									SET @Temp_Log = ' * ACTUALIZA EL ESTADO EN LA TABLA Facturacion.DetalleConsumoeFacturacionOse, PROCESADO Y FECHA DE PROCESO' + '|| ||'
									SET @Temp_LogInsertado = @Temp_LogInsertado + @Temp_Log

									PRINT @Temp_Log

									UPDATE Facturacion.DetalleConsumoeFacturacionOse
									SET Procesado = 1
										,FechaProceso = GETDATE()
									WHERE IdDetalleConsumoeFacturacionOse IN (
											SELECT IdDetalleConsumo
											FROM @Temp_IdDetalleConsumoeFacturacion
											)
								END

							END

							--INSERTAR EL LOG

							INSERT INTO @TempTablaComprobantesInsertados
							VALUES(@IdComprobante, (@Serie + '-' + @NroComprobante), NULL, @IdContratoOse, @Temp_LogInsertado)

							--UPDATE @TempTablaComprobantesInsertados
							--SET LogInsertado = @Temp_LogInsertado
							--WHERE IdComprobanteInsertado = @IdComprobante

						END --FIN IF IDCOMPROBANTE>0
					END --FIN IF IDCOMPROBANTE IS NOT NULL

				END --FINALIZACION  DE LA VALIDACION DE FACTURAMESANTERIOR Y FACTURAPORADELANTADO

			END --FIN IF @EMITIR>0






		END
		SET @ContadorOse = @ContadorOse + 1;
	END; --END WHILE OSE



	SELECT DISTINCT IdComprobanteInsertado
		,ComprobanteInsertado
		,IdContratoInsertado
		,IdContratoOseInsertado
		,LogInsertado
	FROM @TempTablaComprobantesInsertados
	--SELECT @CantidadProcesados AS Cantidad

	--SET NOCOUNT OFF
END
