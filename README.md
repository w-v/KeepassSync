# KeepassSync

synchronizes a kdbx database with an NFS share, or with SSH if the share is not available

includes Keepass2 triggers for executing the script when needed

## Usage

Make a '''conf.sh''' following this format :

    
    SRVS=(  )           # server adresses separated by blanks
    PORT=               # ssh port
    USR=                # ssh user
    CLD_PATH=           # path of the kdbx file on the NFS share
    SSH_PATH=           # path of the kdbx file on ssh server
    TMP_CPY=            # path to the kdbx used by the script as a temp copy 'tmp/passw.kdbx.tmp' should do
    MAIN=               # kdbx database path
    LOG=                # log file path

Copy the triggers to the clipboard, paste them in Keepass (Tools/Triggers/Tools button)
Put the script in the same directory as the database
