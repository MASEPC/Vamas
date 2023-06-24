function sendWork(idtarea) {
    const documento = document.querySelector("#documento").files[0];
    const correo = document.querySelector("#correo");
    const mensaje = document.querySelector("#mensaje");
    const confirmacion = confirm("¿Estás seguro del documento ingresado?");
    if (confirmacion) {
        const formData = new FormData();
        formData.append("op", "sendWork");
        formData.append("idtarea", idtarea);
        formData.append("documento", documento, documento.name);
        formData.append("mensaje", mensaje.value);
        formData.append("correo", correo.value);

        fetch('../controllers/tarea.php', {
            method: 'POST',
            body: formData
        }).then(respuesta => {
            if (respuesta.ok) {
                alert('Trabajo enviado correctamente');
                location.reload();
            } else {
                alert('Error en la solicitud');
            }
        }).catch(error => {
            console.error('Error:', error);
        });
    }
}

function enviarTrabajo(idtarea) {
    const documento = document.querySelector("#documento").files[0];
    const mensaje = document.querySelector("#mensaje").value;
    const porcentaje = document.querySelector("#porcentaje").value;
    const correo = document.querySelector("#correo3").value;
  
    // Validación de campos
    if (!documento || !mensaje || !porcentaje || !correo) {
      alert("Por favor, completa todos los campos.");
      return;
    }
  
    const confirmacion = confirm("¿Estás seguro del documento ingresado?");
    if (confirmacion) {
      const formData = new FormData();
      formData.append("correo", correo)
      formData.append("documento", documento);
      formData.append("mensaje", mensaje);
      formData.append("porcentaje", porcentaje);
      formData.append("idtarea", idtarea);
  
      fetch('../send/upload.php', {
        method: 'POST',
        body: formData
      })
      .then(respuesta => {
        if (respuesta.ok) {
          alert('Trabajo enviado correctamente');
          obtenerIDs(idtarea);
        } else {
          throw new Error('Error en la solicitud');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('Ocurrió un error al enviar el trabajo. Por favor, inténtalo nuevamente.');
      });
    }
  }
  
  function obtenerIDs(idtarea) {
    const formData = new FormData();
    formData.append("op", "obtenerID");
    formData.append("idtarea", idtarea);
  
    fetch('../controllers/tarea.php', {
      method: 'POST',
      body: formData
    })
    .then(respuesta => {
      if (respuesta.ok) {
        return respuesta.json();
      } else {
        throw new Error('Error en la solicitud');
      }
    })
    .then(datos => {
      const idfase = datos.idfase;
      const idproyecto = datos.idproyecto;
      obtenerPorcentajeF(idfase);
      obtenerPorcentajeP(idproyecto);
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }
  
  function obtenerPorcentajeF(idfase) {
    const formData = new FormData();
    formData.append("op", "obtenerPorcentajeF");
    formData.append("idfase", idfase);
  
    fetch('../controllers/fase.php', {
      method: 'POST',
      body: formData
    })
    .then(respuesta => {
      if (respuesta.ok) {
        alert('Fase actualizada correctamente');
      } else {
        throw new Error('Error en la solicitud');
      }
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }
  
  function obtenerPorcentajeP(idproyecto) {
    const formData = new FormData();
    formData.append("op", "obtenerPorcentajeP");
    formData.append("idproyecto", idproyecto);
  
    fetch('../controllers/proyecto.php', {
      method: 'POST',
      body: formData
    })
    .then(respuesta => {
      if (respuesta.ok) {
        alert('Proyecto actualizado correctamente');
      } else {
        throw new Error('Error en la solicitud');
      }
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }
  
  function openModal(id) {
    const modal = document.querySelector("#modalWork"); 
    const asunto = document.querySelector("#asunto"); 
    const idtarea = id; 
  
    const parametrosURL = new URLSearchParams();
    parametrosURL.append("op", "getWork");
    parametrosURL.append("idtarea", id);
  
    fetch('../controllers/tarea.php', {
      method: 'POST',
      body: parametrosURL
    })
    .then(respuesta => {
      if (respuesta.ok) {
        return respuesta.text();
      } else {
        throw new Error('Error en la solicitud');
      }
    })
    .then(datos => {
      datos = JSON.parse(datos); // Si el resultado es un JSON, debes parsearlo
      const btnEnviar = document.querySelector("#enviarTarea");
      asunto.value = datos.nombrefase;
      let idfase = datos.idfase;
      btnEnviar.addEventListener("click", function () {
        // Pasar el valor de idtarea a las siguientes funciones
        enviarTrabajo(idtarea);
      });
  
      const bootstrapModal = new bootstrap.Modal(modal);
      bootstrapModal.show();
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }
  

function listarCorreo(){
    const correo = document.querySelector("#correo3");
    const Ncorreo = document.querySelector("#para");
    const parametros = new URLSearchParams();
    parametros.append("op","listarCorreo");
    fetch(`../controllers/tarea.php`, {
        method: 'POST',
        body: parametros
    })
        .then(respuesta => respuesta.text())
        .then(datos => {
            correo.innerHTML = datos;
        })
        .catch(error => {
            console.error('Error:', error);
        });
}

function list(){
    const table = document.querySelector("#tabla-tareas");
    const bodytable = table.querySelector("tbody");

    const parametrosURL = new URLSearchParams();
    parametrosURL.append("op", "list");

    fetch('../controllers/tarea.php',{
        method: 'POST',
        body: parametrosURL
    })
    .then(respuesta => {
        if(respuesta.ok){
            return respuesta.text();
        } else{
            throw new Error('Error en la solicitud');
        }
    })
    .then(datos =>{
        bodytable.innerHTML = datos;
    })
    .catch(error => {
        console.error('Error:', error);
    });
}

listarCorreo();
list();