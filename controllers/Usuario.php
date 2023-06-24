<?php
//Iniciamos/heredamos la sesión
session_start();

//La sesión contendrá datos del login en formato de arreglo
$_SESSION["login"] = [];

require_once '../models/Usuario.php';
require_once '../models/Mail.php';

if (isset($_POST['operacion'])){

  $usuario = new Usuario();

  if ($_POST['operacion'] == 'login'){
    //Buscamos al usuario a través de su nombre
    $datoObtenido = $usuario->login($_POST['colaborador']);
    //Arreglo que contiene datos de login
    $resultado = [
      "status"        => false,
      "usuario"     => "",
      "clave"       => "",
      "gmail"   => "",
      "mensaje"       => ""
    ];
    
    if ($datoObtenido){
      //Encontramos el registro
      $claveEncriptada = $datoObtenido['claveacceso'];
      if (password_verify($_POST['claveIngresada'], $claveEncriptada)){
        //Clave correcta
        $resultado["status"] = true;
        $resultado["usuario"] = $datoObtenido["usuario"];
        $resultado["clave"] = $datoObtenido["clave"];
        $resultado["gmail"] = $datoObtenido["gmail"];
      }else{
        //Clave incorrecta
        $resultado["mensaje"] = "Contraseña incorrecta";
      }
    }else{
      //Usuario no encontrado
      $resultado["mensaje"] = "No se encuentra el usuario";
    }

    //Actualizando la información en la variable de sesión
    $_SESSION["login"] = $resultado;
    
    //Enviando información de la sesión a la vista
    echo json_encode($resultado);
  }

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
        "gmail"           => $_POST['gmail'],
        "clavegenerada"   => $valRandom
      ];

      // Creando registro
      $usuario->restoure($data);

      //Enviando Correo
      sendEmail($_POST['gmail'], 'Código de restauración: ', $mensaje);
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

if (isset($_GET['operacion']) == 'destroy'){
  session_destroy();
  session_unset();
  header("location:../");
}

?>