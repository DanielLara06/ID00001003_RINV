import logging, time
from ipdi.ip.pyaip import pyaip, pyaip_init

## IP Normalizer driver class
class RINV:
    ## Class constructor of IP Normalizer driver
    #
    # @param self Object pointer
    # @param targetConn Middleware object
    # @param config Dictionary with IP Dummy configs
    # @param addrs Network address IP
    def __init__(self, connector, nic_addr, port, csv_file):
        ## Pyaip object
        self.__pyaip = pyaip_init(connector, nic_addr, port, csv_file)

        if self.__pyaip is None:
            logging.debug(error)

        ## Array of strings with information read
        self.dataRX = []

        ## IP Dummy IP-ID
        self.IPID = 0

        self.__getID()

        self.__clearStatus()

        logging.debug(f"IP Dummy controller created with IP ID {self.IPID:08x}")

    ## Write data in the IP Dummy input memory
    #
    # @param self Object pointer
    # @param data String array with the data to write

    def INV(self,R,N):
        try:
            self.IPID = self.__pyaip.getID()
            logging.debug(f"IP R_INV controller created with IP ID {self.IPID:08x}")

            status = self.__pyaip.getStatus()

            logging.info(f"{status:08x}")

            ## Show IP Dummy status
            #
            # @param self Object pointer
            def status(self):
                status = self.__pyaip.getStatus()
                logging.info(f"{status:08x}")

            ## S_H Write Data
            self.__pyaip.writeMem('MMEM_R_I', R, len(R), 0)
            logging.debug("Data captured in Mem Data In R")

            ## ConF_Reg Write
            # conf_register = 1349  # shape_full_same+size_y+size_x
            conf_register = N #(Symb << 6) | N
            logging.info(conf_register)
            timeDelay = []

            timeDelay.append(conf_register)
            self.__pyaip.writeConfReg('CCONF', timeDelay, 1, 0)
            logging.debug(f"Configuration Register setted up with size: {N}")

            ## Start()
            self.__pyaip.start()
            # logging.info("Start sent")

            ## Wait for the completion of the process
            #
            # @param self Object pointer

            waiting = True
            while waiting:
                status = self.__pyaip.getStatus()
                logging.debug(f"status {status:08x}")

                if status & 0x1:
                    waiting = False
                time.sleep(0.1)

            status = self.__pyaip.getStatus()
            logging.info(f"{status:08x}")

            ## Show IP Dummy status
            #
            # @param self Object pointer
            def status(self):
                status = self.__pyaip.getStatus()
                logging.info(f"{status:08x}")

            ## Clear status register of IP Dummy
            #
            # @param self Object pointer
            for i in range(8):
                self.__pyaip.clearINT(i)

            status = self.__pyaip.getStatus()
            logging.info(f"{status:08x}")

            ## Show IP Dummy status
            #
            # @param self Object pointer
            def status(self):
                status = self.__pyaip.getStatus()
                logging.info(f"{status:08x}")

            ## Read Memory H_Norm
            inverse = self.__pyaip.readMem('MMEM_R_INV_O', 2304, 0)
            logging.debug("Data obtained from Mem H Norm")

            return inverse
        except:
            ## Finish connection
            #
            # @param self Object pointer
            self.__pyaip.finish()




    def __getID(self):
        self.IPID = self.__pyaip.getID()

        ## Clear status register of IP Dummy
        #
        # @param self Object pointer

    def __clearStatus(self):
        for i in range(8):
            self.__pyaip.clearINT(i)

    ## Disable IP Dummy interruptions
    #
    # @param self Object pointer
    def disableINT(self):
        self.__pyaip.disableINT(0)

        logging.debug("Int disabled")


if __name__=="__main__":
    import numpy as np
    import sys
    import random
    import time, os

    logging.basicConfig(level=logging.INFO)
    connector = 'COM4'
    csv_file = 'C:/Dani/Cores/R_INV2/R_INV_AIP/ID00001003_config.csv'
    addr = 1
    port = 0

    try:
        rinv = RINV(connector, addr, port, csv_file)
        logging.info("Test R_INV: Driver created")

        logging.info(f"IP R_INV controller created with IP ID {rinv.IPID:08x}")
    except:
        logging.error("Test R_INV: Driver not created")
        sys.exit()

    i = 10000
    N = 48

    # For loop para el conjunto de realizaciones
    for d in range(267,i):
        ## Show IP Dummy status
        #
        # @param self Object pointer
        def status(self):
            status = self.__pyaip.getStatus()
            logging.info(f"{status:08x}")

        rinv.disableINT()

        R = []
        r = "C:/Dani/Cores/R_INV2/R_INV_AIP/ID00001003_Driver/LoS/R"
        i_s = str(d)
        r2 = r + i_s + ".txt"
        with open(r2, 'r') as file_R:
            # Leer el archivo línea por línea
            for line in file_R:
                # Eliminar el salto de línea al final de cada línea
                line = (int(line.strip(), 2))
                # Agregar la línea a la lista
                R.append(line)
        file_R.close()
        #logging.info(f"Data generated with {len(R):d}")
        #logging.info(f'TX Data {[f"{x:032b}" for x in R]}')

        inverse = rinv.INV(R,N)

        # line3 = 0
        address = "C:/Dani/Cores/R_INV2/R_INV_AIP/ID00001003_Driver/R_INV_LoS/"
        R_INV_o = "R_INV_"
        i_s = str(d)
        R_INV_O = address + R_INV_o + i_s + ".txt"
        with open(R_INV_O, 'w') as file_R_INV:
            # Leer el archivo línea por línea
            for line3 in range(0, 2304):
                # Eliminar el salto de línea al final de cada línea
                aux = (int(inverse[line3]))
                # logging.info(f'H_Norm Data: {[f"{x:08x}" for x in (S_HNORM)]}')
                # print(str(aux[line3]))
                file_R_INV.write("{:032b}\n".format(aux))
        file_R_INV.close()
        logging.info(f'Iter: "{d:d}"')

        #logging.info(f'R_INV Data: {[f"{x:032b}" for x in inverse]}')
        # logging.info(f'Y_Norm Data: {[f"{x:08d}" for x in S_YNORM]}')

        # GM = (np.convolve(S_X,S_Y))