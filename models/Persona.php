<?php

    require_once 'conexion.php';

    class Persona extends Conexion{
        private $conexion;

        public function __construct(){
            $this->conexion = parent::getConexion();
        }

        public function listar(){
            try {
                $consulta = $this->conexion->prepare("SELECT * FROM personas");
                $consulta->execute();
                $datos = $consulta->fetchAll(PDO::FETCH_ASSOC);
                return $datos;
            } catch (Exception $e) {
                die($e->getMessage());
            }
        }

        public function getDatos($idpersona){
            try {
                $consulta = $this->conexion->prepare("SELECT * FROM personas where idpersona = ?");
                $consulta->execute(array($idpersona));
                $datos = $consulta->fetch(PDO::FETCH_ASSOC);
                return $datos;
            } catch (Exception $e) {
                die($e->getMessage());
            }
        }

        public function registrarPersona($datos){
            try {
                $consulta = $this->conexion->prepare("INSERT INTO personas(apellidos,nombres,tipodocumento,nrodocumento,telefono,direccion,fechanac) VALUES(?,?,?,?,?,?,?)");
                $consulta->execute(array(
                    $datos['apellidos'],
                    $datos['nombres'],
                    $datos['tipodocumento'],
                    $datos['nrodocumento'],
                    $datos['telefono'],
                    $datos['direccion'],
                    $datos['fechanac']
                ));
            } catch (Exception $e) {
                die($e->getMessage());
            }         

        }

        public function getID($nrodcumento){
            try {
                $consulta = $this->conexion->prepare("call obtener_idpersona(?)");
                $consulta->execute(array($nrodcumento));
                $datos = $consulta->fetch(PDO::FETCH_ASSOC);
                return $datos;
            } catch (Exception $e) {
                die($e->getMessage());
            }
        }




        // Funciones para recuperar clave - actualizar y buscar

        public function searchUser($nombreUsuario = ''){
            try{
              $query = "SELECT idusuario, apellidos,nombres,email FROM usuarios WHERE nombreusuario = ? AND estado = 1";
              $consulta = $this->conexion->prepare($query);
              $consulta->execute(array($nombreUsuario));
        
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
                $data['idusuario'],
                $data['email'],
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
                $data['idusuario'],
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
                $data['idusuario']
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
                $data['idusuario'],
                $data['claveacceso']
              ));
              return $resultado;
            }
            catch(Exception $e){
              die($e->getMessage());
            }
          }

    } //fin de la conexion

?>