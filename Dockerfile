FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

# copy ไฟล์เว็บที่ build มาแล้ว
COPY build/web/ /usr/share/nginx/html/

# copy คอนฟิก nginx ของเรา
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]