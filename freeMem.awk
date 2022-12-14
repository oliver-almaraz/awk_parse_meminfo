# Script awk para procesar el fichero /proc/meminfo, obtener
# el porcentaje de memoria disponible (Available) y mostrar
# una advertencia si es menor al límite inferior LOW_LIMIT.
# Ejemplo de uso:
# ssh -qx 'cat /proc/meminfo' | awk -f freeMem.awk LOW_LIMIT=35
#
# https://github.com/oliver-almaraz/awk_parse_meminfo

BEGIN {
    # El límite inferor de porcentaje de memoria DISPONIBLE
    # (available for starting new appliations, without swapping)
    if (ARGC != 2)
        LOW_LIMIT=20
}

/^MemTotal/ { TOTAL=$2 }
/^MemAvailable/ { AVAILABLE=$2 }

END {
    if (TOTAL < 1){
        print "Error al procesar /proc/meminfo" > "/dev/stderr"
	exit -1
    }
    PERCENT_AVAIL= AVAILABLE / TOTAL * 100
    if (PERCENT_AVAIL < LOW_LIMIT){
        printf("Advertencia: solo el %d%c de memoria está disponible\n", PERCENT_AVAIL, "%")
        exit 42 # Do stuff with return val from caller proc
    }
    else {
        printf("Memoria disponible (Available): %d%c\n", PERCENT_AVAIL, "%")
	exit 0
    }
}
