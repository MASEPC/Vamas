<?php

require_once 'conexion.php';

class Usuario extends Conexion {
    private $conexion;

    public function __construct(){
        $this->conexion = parent::getConexion();
    }
    public function registrar($idpersona,$titulo,$descripcion,$fechainicio,$fechafin,$precio,$idusuariore){
            try {
                $consulta = $this->conexion->prepare("INSERT INTO proyecto (idtipoproyecto,idempresa,titulo, descripcion, fechainicio,fechafin,precio,idusuariore) values (?,?,?,?,?,?,?,?)");
                $consulta->execute(array($idtipoproyecto, $idempresa, $titulo, $descripcion, $fechainicio, $fechafin, $precio,$idusuariore));
            } catch (Exception $e) {
                die($e->getMessage());
            }
        }
    }
?>
