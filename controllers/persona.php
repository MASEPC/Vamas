<?php
    session_start();
    require_once '../models/Persona.php';

    if (isset($_POST['op'])) {

        $persona = new Persona();

        if ($_POST['op'] == 'listar') {
            $datos = $persona->listar();
            echo json_encode($datos);
        }
        
        if ($_POST['op'] == 'getDatos') {
            $idpersona = $_POST['idpersona'];
            $datos = $persona->getDatos($idpersona);
            echo json_encode($datos);
        }
        if ($_POST['op'] == 'registrarPersona') {
            $datos = [
                "apellidos" => $_POST['apellidos'],
                "nombres" => $_POST['nombres'],
                "tipodocumento" => $_POST['tipodocumento'],
                "nrodocumento" => $_POST['nrodocumento'],
                "telefono" => $_POST['telefono'],
                "direccion" => $_POST['direccion'],
                "fechanac" => $_POST['fechanac']
                
            ];
            $persona->registrarPersona($datos);
        }

        if ($_POST['op'] == 'getID') {
            $nrodocumento = $_POST['nrodocumento'];
            $datos = $persona->getID($nrodocumento);
            echo json_encode($datos);
        }




        // Funciones para recuperar clave:
        if ($_POST['operacion'] == 'searchUser') {
            $datoObtenido = $usuario->searchUser($_POST['user']);
            if ($datoObtenido) {
              echo json_encode($datoObtenido);
            }
          }
        
          if ($_POST['operacion'] == 'sendEmail') {
        
            // Validar que este proceso NO SE EJECUTE SINO HASTA DESPUES DE 15 MINUTOS
            $respuesta = $usuario->validarTiempo(['idusuario' => $_POST['idusuario']]);
            $retorno = ["mensaje" => "Ya se envió una clave, revise su correo"];
        
            if ($respuesta["status"] == "GENERAR") {
              // Crear un valor aleatorio de 4 dígitos
              $valRandom = random_int(1000, 9999);
        
              // Cuerpo del mensaje
              $mensaje = "
              <h3>App SENATI</h3>
              <strong>Recuperación de cuenta</strong>
              <hr>
              <p>Estimado usuario, para recuperar el acceso, utilice el siguiente código</p>
              <h3>{$valRandom}</h3>
              ";
        
              // Arreglo con datos a guardar en la tabla de recuperación
              $data = [
                "idusuario"       => $_POST['idusuario'],
                "email"           => $_POST['email'],
                "clavegenerada"   => $valRandom
              ];
        
              // Creando registro
              $usuario->restoure($data);
        
              //Enviando Correo
              sendEmail($_POST['email'], 'Código de restauración: ', $mensaje);
              $retorno["mensaje"] = "Se ha generado y enviado la clave al email indicado";
            }
            // Enviando el mensaje
            echo json_encode($retorno);
          }
        
          if ($_POST['operacion'] == 'validarClave') {
            $datos = [
              "idusuario"       => $_POST['idusuario'],
              "clavegenerada"   => $_POST['clavegenerada']
            ];
            $resultado = $usuario->validarClave($datos);
            echo json_encode($resultado);
          }
        
          // Prueba de validación de tiempo
          if ($_POST['operacion'] == 'validarTiempo') {
            $datos = [
              "idusuario"       => $_POST['idusuario']
            ];
            $resultado = $usuario->validarTiempo($datos);
            echo json_encode($resultado);
          }
        
          if ($_POST['operacion'] == 'actualizarClave') {
            $claveEncriptada = password_hash($_POST['claveacceso'], PASSWORD_BCRYPT);
            $idusuario = $_POST['idusuario'];
            $datos = [
              "idusuario"     => $idusuario,
              "claveacceso"   => $claveEncriptada
            ];
            echo json_encode($usuario->actualizarClave($datos));  
          }
    }

?>