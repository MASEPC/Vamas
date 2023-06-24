<?php

require_once 'Conexion.php';

class Usuario extends Conexion{

  private $conexion;

  public function __CONSTRUCT(){
    $this->conexion = parent::getConexion();
  }

  public function login($usuario = ''){
    try{
      $consulta = $this->conexion->prepare("SELECT * FROM colaboradores WHERE usuario = ?");
      $consulta->execute(array($usuario));

      return $consulta->fetch(PDO::FETCH_ASSOC);
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function searchUser($usuario = ''){
    try{
      $query = "SELECT idcolaborador, usuario,clave,gmail FROM colaboradores WHERE usuario = ? AND estado = 1";
      $consulta = $this->conexion->prepare($query);
      $consulta->execute(array($usuario));

      return $consulta->fetch(PDO::FETCH_ASSOC);
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function restoure($data = []){
    try{
      $query = "CALL recuperar_clave(?,?,?)";
      $consulta = $this->conexion->prepare($query);
      $consulta->execute(array(
        $data['idcolaborador'],
        $data['gmail'],
        $data['clavegenerada']
      ));
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }



  // Retornará: PERMITIDO / DENEGADO
  // Se sugiere retornar bool/int/string
  public function validarClave($data = []){
    try{
      $query = "CALL spu_usuario_validarclave(?,?)";
      $consulta = $this->conexion->prepare($query);
      $consulta->execute(array(
        $data['idcolaborador'],
        $data['clavegenerada']
      ));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function validarTiempo($data = []){
    try{
      $query = "CALL spu_usuario_validartiempo(?)";
      $consulta = $this->conexion->prepare($query);
      $consulta->execute(array(
        $data['idcolaborador']
      ));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function actualizarClave($data = []){
    $resultado = ["status" => false];
    try{
      $query = "CALL spu_usuarios_actualizarclave(?,?)";
      $consulta = $this->conexion->prepare($query);
      $resultado["status"] =$consulta->execute(array(
        $data['idcolaborador'],
        $data['clave']
      ));
      return $resultado;
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }

}