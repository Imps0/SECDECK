# Pipeline DevSecOps do SECDECK

## Fluxo

1. **Secrets — Gitleaks:** varredura do histórico Git completo; achados bloqueiam a pipeline.
2. **SAST — Semgrep:** regras `p/default` e `p/owasp-top-ten`; achados de erro bloqueiam a pipeline até análise/correção.
3. **Build/teste:** valida arquivos essenciais, referências locais e constrói a imagem Docker; não há framework de testes identificado no projeto original.
4. **SCA/configuração — Trivy filesystem:** gera relatório completo e JSON filtrado para HIGH/CRITICAL; bloqueia nesses níveis.
5. **Docker + GHCR:** publica tags `sha-<commit>` e `latest` para conveniência; deploys devem usar a tag SHA, nunca `latest`.
6. **Scan da imagem — Trivy:** examina a imagem publicada e bloqueia vulnerabilidades corrigíveis HIGH/CRITICAL.
7. **Homologação + ZAP:** aciona o serviço de homologação e executa ZAP Baseline somente contra `STAGING_URL` autorizado. O resultado é informativo, conforme o enunciado.
8. **Aprovação + produção:** job associado ao environment `producao`; o deploy só continua após os revisores obrigatórios aprovarem.

## Relatórios

O workflow publica relatórios JSON/Markdown como artifacts de cada etapa e produz um resumo final mesmo se algum job falhar ou for ignorado. O resumo informa estados dos jobs; os detalhes dos achados permanecem nos artifacts.

## Homologação e produção

Para esta demonstração, Render pode hospedar serviços de imagem pré-construída do GHCR. Criar dois serviços distintos, um para homologação e outro para produção, e configurar os deploy hooks como GitHub Secrets. O plano gratuito pode suspender serviços ociosos e não deve ser considerado adequado a uma aplicação crítica.
