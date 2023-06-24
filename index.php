<?php

 session_start();

//¡CUIDADO!
//Si el usuario YA inició sesión, NO debe visualizar este view
if (isset($_SESSION['login']) && $_SESSION['login'] == true){
    header("location:views/");
  }

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap 5.2 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <title>Inicio de Sesion</title>
</head>
<body>
    
    <div class="container">
        <form action="" autocomplete="off">
        <div class="row">
            <div class="col-md-3"></div>
            <div class="col-md-6">
                <!-- Formulario de inicio de sesión -->
                <h3 class="mt-3">Inicio de sesión</h3>
                <div class="form-group mb-4">
                    <label for="email">Escriba su correo</label>
                    <input type="email" class="form-control" id="email" placeholder="micorreo@gmail.com">
                </div>

                <div class="form-group mb-4">
                    <label for="clave">Contraseña</label>
                    <input type="password" class="form-control" id="clave">
                </div>

                <div class="form-group text-right mb-3">
                    <button class="btn btn-outline-info me-3" id="acceder" type="button">Acceder</button>
                    <a class="btn  btn-outline-dark" id="registrar" href="registrar.php">Registrarse</a>
                </div>
                <a href="./contraseña.php">Olvidé mi contraseña</a>
                <!-- Fin del formulario -->
            </div>
            <div class="col-md-3"></div>
        </div> <!-- Fin row -->
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js" integrity="sha384-cuYeSxntonz0PPNlHhBs68uyIAVpIIOZZ5JqeqvYYIcEL727kskC66kF92t6Xl2V" crossorigin="anonymous"></script>
  

   <script src="views/js/login.js">
   </script>


</body>
</html>