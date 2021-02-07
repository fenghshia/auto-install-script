python -m pip install -U jupyterlab
python -m jupyter notebook --generate-config
sed -i "s/# c.NotebookApp.allow_origin = ''/c.NotebookApp.allow_origin = '*'/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/# c.NotebookApp.allow_root = False/c.NotebookApp.allow_root = True/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/# c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/# c.NotebookApp.open_browser = True/c.NotebookApp.open_browser = False/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/# c.NotebookApp.port = 8888/c.NotebookApp.port = 8000/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/# c.NotebookApp.notebook_dir = ''/c.NotebookApp.notebook_dir = '\/opt\/dataroot\/fenghshia\/files\/jupyter-space'/g" /root/.jupyter/jupyter_notebook_config.py
# from notebook.auth import passwd; passwd()
sed -i "s/# c.NotebookApp.password = ''/c.NotebookApp.password = 'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$uvElaY9qR78b86aAgVldgA\$gaZzeZ8fZzIYg6BiShCvag'/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/# c.NotebookApp.token = '<generated>'/c.NotebookApp.token = 'ylsn74229986.'/g" /root/.jupyter/jupyter_notebook_config.py

touch jupyterctl
chmod 777 jupyterctl
echo "case \"\$1\" in
    start)
        \`nohup python -m jupyterlab >> /opt/dataroot/fenghshia/files/log/jupyter.log 2>&1 &\`
        ;;
    stop)
        \`nohup ps aux | grep jupyterlab | awk '{print \$2}' | xargs kill -9 2>&1 &\`
        ;;
    restart)
        \$0 stop
        \$0 start
        ;;
    *)
        echo \"Usage: \$0 {start|stop|restart}\"
        exit 1
        ;;
esac" > jupyterctl
sudo -u www-data touch /opt/dataroot/fenghshia/files/log/jupyter.log
./jupyterctl start
