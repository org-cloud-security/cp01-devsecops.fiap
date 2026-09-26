## iac 
checkov: SAST especializado em IaC


## app
owasp zap: DAST 
owasp dependency-check: SCA
semgrep: SAST utilizado em APP e IaC


## questions 

1. o que é o SAST? 
- é uma técnica essencial na segurança cibernética proativa que envolve a verificação automática de vulnerabilidades no código-fonte antes da execução do código. 

2. checkov se enquadra como SAST? 
- Sim, porém é especializado em infraestrutura como código

3. O que é o DAST?
-  É o processo de usar ataques simulados em um aplicativo web para identificar vulnerabilidades

4. o que é Owasp Zap?
- Ferramenta de DAST para realizar testes de penetração em web apps 

5. O que é Owasp?
- O Open Web Application Security Project, ou OWASP, é uma organização internacional sem fins lucrativos dedicada à segurança de aplicativos web. 

6. O que é o Owasp top 10? 
- O OWASP Top 10 é um relatório atualizado regularmente que resume questões de segurança de aplicativos web baseado nos 10 riscos mais críticos

7. O que é um SCA? 
Software Composition Analysis - é uma técnica usada para examinar os componentes de software que compõem um aplicativo e, em seguida, identificar e gerenciar quaisquer vulnerabilidades descobertas. 

8. O que é SBOM 
SBOM (Software Bill of Materials) é a "lista de ingredientes" de um software: um inventário de todos os componentes que ele usa, como bibliotecas, dependências, versões e licenças.

9. Como funciona o fluxo do sca com checkov? 
- Não tem como pq é necessário uma lincensa do prisma cloud 

10. eu preciso rodar o npm run build para rodar o sca? 
- Não preciso executar,ocorre a analise de dependencias através de arquivos como o package.json 


## ferramentas pipeline cp 

1. pipe de iac 
    - SAST » checkov 

2. pipe de app 
    - SAST » semgrep
    - DAST » zap 
    - SCA  » owasp-dependency-check

## fluxo pipeline 

1. pipe de iac 
    - PR:
        - fmt 
        - validate 
        - sast
        - init 
        - plan
    - Merge: 
        - init 
        - plan 
        - apply

2. pipe de app
    - PR:
        - sast: semgrep 
        - sca: owasp-dependency-check
        - docker build
    
    - Merge:
        - docker build & docker push 
        - atualiza tag do container 
        - trigger pipe cron dast  
        - schedule imediato com o acionamento do trigger 
        - condicional: 
            - se tem vulnerabilidade, rollback para tag anterior do container 
            - se não tem vulnerabilidade finaliza a pipe


## docs 

https://www.crowdstrike.com/en-us/cybersecurity-101/cloud-security/static-application-security-testing-sast/
https://www.checkov.io/1.Welcome/What%20is%20Checkov.html
https://www.checkov.io/3.Custom%20Policies/Custom%20Policies%20Overview.html
https://www.fortinet.com/br/resources/cyberglossary/dynamic-application-security-testing
https://www.cloudflare.com/pt-br/learning/security/threats/owasp-top-10/
https://semgrep.dev/explore
http://crowdstrike.com/en-us/cybersecurity-101/cloud-security/software-composition-analysis/
https://owasp.org/projects/dependency-check
https://www.zaproxy.org/blog/2020-04-09-automate-security-testing-with-zap-and-github-actions/
http://zaproxy.org/blog/2020-05-15-dynamic-application-security-testing-with-zap-and-github-actions/