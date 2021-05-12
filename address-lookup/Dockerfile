FROM ggotti/g-naf-full-sqlite:latest

ADD ./data-prep /root/data-prep
RUN /root/data-prep/establishDatabase.sh

FROM public.ecr.aws/lambda/nodejs:14
COPY --from=0 /address/address.db ./
COPY app.js package.json ./

RUN npm install


RUN chmod a+r app.js

# Command can be overwritten by providing a different command in the template directly.
CMD ["app.lambdaHandler"]
