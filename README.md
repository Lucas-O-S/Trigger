## E: Time de Suporte e Atendimento ao Cliente

### Q: Uma automação na criação de tarefas nos casos de suporte técnico

### P: Não termos mais de uma task aberta ao mesmo tempo para o mesmo caso

---

### ✅ Ação proposta:

Construir uma **trigger** com a seguinte lógica:

- Ao criar uma nova tarefa, verificar se já existe **uma tarefa em aberto** associada ao mesmo **objeto Caso**.
- Se **já houver uma tarefa em aberto**, impedir a criação da nova tarefa e exibir a seguinte **mensagem de erro**:

  > “Já existe uma tarefa em aberto nesse caso. Encerre-a antes de abrir uma nova.”

- Se **não houver tarefas em aberto**, permitir a criação normalmente.

⚠️ **Importante:** Toda trigger deve funcionar para **cenários de carga de dados (bulk)**, **nunca apenas para um único registro**.

---

