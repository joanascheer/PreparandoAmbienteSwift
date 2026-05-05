import Foundation

// Domínios fechados

enum NivelExperiencia: String {
    case iniciante = "Iniciante"
    case intermediario = "Intermediário"
    case avancado = "Avançado"
}

enum CategoriaAula: String {
    case musculacao = "Musculação"
    case spinning = "Spinning"
    case yoga = "Yoga"
    case funcional = "Funcional"
    case luta = "Luta"
}

// Entidade Plano de Assinatura

struct PlanoAssinatura {
    let nome: String
    let valorMensalidade: Double
    let incluiPersonalTrainer: Bool
    let limiteAulasColetivas: Int
    let duracaoMeses: Int
}

// Catálogo em memória

struct CatalogoPlanos {
    static let mensal = PlanoAssinatura(
        nome: "Mensal",
        valorMensalidade: 149.90,
        incluiPersonalTrainer: false,
        limiteAulasColetivas: 8,
        duracaoMeses: 1
    )

    static let trimestral = PlanoAssinatura(
        nome: "Trimestral",
        valorMensalidade: 129.90,
        incluiPersonalTrainer: false,
        limiteAulasColetivas: 12,
        duracaoMeses: 3
    )

    static let anual = PlanoAssinatura(
        nome: "Anual",
        valorMensalidade: 99.90,
        incluiPersonalTrainer: true,
        limiteAulasColetivas: 20,
        duracaoMeses: 12
    )

    static let todos: [PlanoAssinatura] = [
        mensal,
        trimestral,
        anual
    ]
}

// Entidade Pessoa usada como base

class Pessoa {
    let nome: String
    let email: String
    let funcao: String

    init(nome: String, email: String, funcao: String) {
        self.nome = nome
        self.email = email
        self.funcao = funcao
    }

    func descrever() {
        print("Nome: \(nome)")
        print("E-mail: \(email)")
        print("Função: \(funcao)")
    }
}

// Entidade Aluno

class Aluno: Pessoa {
    let matricula: String
    private(set) var plano: PlanoAssinatura
    private(set) var nivel: NivelExperiencia

    init(
        nome: String,
        email: String,
        matricula: String,
        plano: PlanoAssinatura,
        nivel: NivelExperiencia
    ) {
        self.matricula = matricula
        self.plano = plano
        self.nivel = nivel

        super.init(
            nome: nome,
            email: email,
            funcao: "Aluno"
        )
    }

    func atualizarPlano(_ novoPlano: PlanoAssinatura) {
        self.plano = novoPlano
    }

    func atualizarNivel(_ novoNivel: NivelExperiencia) {
        self.nivel = novoNivel
    }

    override func descrever() {
        super.descrever()
        print("Matrícula: \(matricula)")
        print("Plano: \(plano.nome)")
        print("Nível: \(nivel.rawValue)")
    }
}

// Entidade Instrutor

class Instrutor: Pessoa {
    let especialidade: CategoriaAula

    init(
        nome: String,
        email: String,
        especialidade: CategoriaAula
    ) {
        self.especialidade = especialidade

        super.init(
            nome: nome,
            email: email,
            funcao: "Instrutor"
        )
    }

    override func descrever() {
        super.descrever()
        print("Especialidade: \(especialidade.rawValue)")
    }
}

// Contrato de Manutenção

protocol Manutencao {
    var nomeItem: String { get }
    var historico: [String] { get }

    mutating func realizarReparo(data: String, regular: Bool) -> Bool
}

// Estado do Equipamento

enum EstadoFuncionamento: String {
    case funcionando = "Funcionando"
    case defeituoso = "Defeituoso"
}

// Equipamento Físico

struct EquipamentoFisico: Manutencao {
    let nomeItem: String
    var historico: [String]
    var estado: EstadoFuncionamento

    init(nomeItem: String, estado: EstadoFuncionamento) {
        self.nomeItem = nomeItem
        self.estado = estado
        self.historico = []
    }

    mutating func realizarReparo(data: String, regular: Bool) -> Bool {
        if estado == .defeituoso {
            let registro = "Data: \(data) | Falha na manutenção | Equipamento defeituoso"
            historico.append(registro)
            return false
        }

        let status = regular ? "Regular" : "Irregular"
        let registro = "Data: \(data) | Reparo realizado | Status: \(status)"
        historico.append(registro)

        return true
    }
}

// Contrato Base de Aula

protocol Aula {
    var nome: String { get }
    var instrutor: Instrutor { get }
    var categoria: CategoriaAula { get }
    var descricao: String { get }
}

// Turma Coletiva

class TurmaColetiva: Aula {
    let nome: String
    let instrutor: Instrutor
    let categoria: CategoriaAula
    let descricao: String

    let capacidadeMaxima: Int
    let capacidadeMinima: Int

    private(set) var alunosInscritos: [Aluno]

    init(
        nome: String,
        instrutor: Instrutor,
        categoria: CategoriaAula,
        descricao: String,
        capacidadeMaxima: Int,
        capacidadeMinima: Int
    ) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.capacidadeMaxima = max(capacidadeMaxima, capacidadeMinima)
        self.capacidadeMinima = capacidadeMinima
        self.alunosInscritos = []
    }

    @discardableResult
    func inscreverAluno(_ aluno: Aluno) -> Bool {
        if alunosInscritos.contains(where: { $0.matricula == aluno.matricula }) {
            print("Aluno \(aluno.nome) já está inscrito na turma \(nome).")
            return false
        }

        if alunosInscritos.count >= capacidadeMaxima {
            print("Não há vagas disponíveis na turma \(nome).")
            return false
        }

        alunosInscritos.append(aluno)
        print("Aluno \(aluno.nome) inscrito com sucesso na turma \(nome).")
        return true
    }

    func possuiQuantidadeMinima() -> Bool {
        return alunosInscritos.count >= capacidadeMinima
    }

    func listarInscritos() {
        print("Turma: \(nome)")
        print("Alunos inscritos:")

        if alunosInscritos.isEmpty {
            print("Nenhum aluno inscrito.")
        } else {
            for aluno in alunosInscritos {
                print("- \(aluno.nome) | Matrícula: \(aluno.matricula)")
            }
        }
    }
}

// Treino com Personal

class TreinoPersonal: Aula {
    let nome: String
    let instrutor: Instrutor
    let categoria: CategoriaAula
    let descricao: String

    let aluno: Aluno
    let objetivo: String
    let dataAgendada: String

    init(
        nome: String,
        instrutor: Instrutor,
        categoria: CategoriaAula,
        descricao: String,
        aluno: Aluno,
        objetivo: String,
        dataAgendada: String
    ) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.aluno = aluno
        self.objetivo = objetivo
        self.dataAgendada = dataAgendada
    }

    func descreverTreino() {
        print("Treino Personal: \(nome)")
        print("Data agendada: \(dataAgendada)")
        print("Aluno: \(aluno.nome)")
        print("Instrutor: \(instrutor.nome)")
        print("Categoria: \(categoria.rawValue)")
        print("Objetivo: \(objetivo)")
        print("Descrição: \(descricao)")
    }
}

// Gerenciamento Central da Academia

class Academia {
    let nome: String

    fileprivate var alunosPorMatricula: [String: Aluno]
    fileprivate var alunosPorEmail: [String: Aluno]
    fileprivate var instrutoresPorEmail: [String: Instrutor]
    fileprivate var equipamentosPorNome: [String: EquipamentoFisico]
    fileprivate var turmasColetivas: [String: TurmaColetiva]
    fileprivate var treinosPersonal: [String: TreinoPersonal]

    init(nome: String) {
        self.nome = nome
        self.alunosPorMatricula = [:]
        self.alunosPorEmail = [:]
        self.instrutoresPorEmail = [:]
        self.equipamentosPorNome = [:]
        self.turmasColetivas = [:]
        self.treinosPersonal = [:]
    }

    @discardableResult
    func cadastrarAluno(_ aluno: Aluno) -> Bool {
        if alunosPorMatricula[aluno.matricula] != nil {
            print("Erro: já existe aluno cadastrado com a matrícula \(aluno.matricula).")
            return false
        }

        if alunosPorEmail[aluno.email] != nil || instrutoresPorEmail[aluno.email] != nil {
            print("Erro: já existe usuário cadastrado com o e-mail \(aluno.email).")
            return false
        }

        alunosPorMatricula[aluno.matricula] = aluno
        alunosPorEmail[aluno.email] = aluno

        print("Aluno \(aluno.nome) cadastrado com sucesso.")
        return true
    }

    @discardableResult
    func cadastrarInstrutor(_ instrutor: Instrutor) -> Bool {
        if instrutoresPorEmail[instrutor.email] != nil || alunosPorEmail[instrutor.email] != nil {
            print("Erro: já existe usuário cadastrado com o e-mail \(instrutor.email).")
            return false
        }

        instrutoresPorEmail[instrutor.email] = instrutor

        print("Instrutor \(instrutor.nome) cadastrado com sucesso.")
        return true
    }

    @discardableResult
    func cadastrarEquipamento(_ equipamento: EquipamentoFisico) -> Bool {
        if equipamentosPorNome[equipamento.nomeItem] != nil {
            print("Erro: já existe equipamento cadastrado com o nome \(equipamento.nomeItem).")
            return false
        }

        equipamentosPorNome[equipamento.nomeItem] = equipamento

        print("Equipamento \(equipamento.nomeItem) cadastrado com sucesso.")
        return true
    }

    @discardableResult
    func cadastrarTurmaColetiva(_ turma: TurmaColetiva) -> Bool {
        if turmasColetivas[turma.nome] != nil {
            print("Erro: já existe turma cadastrada com o nome \(turma.nome).")
            return false
        }

        turmasColetivas[turma.nome] = turma

        print("Turma \(turma.nome) cadastrada com sucesso.")
        return true
    }

    func buscarAlunoPorMatricula(_ matricula: String) -> Aluno? {
        return alunosPorMatricula[matricula]
    }

    func buscarAlunoPorEmail(_ email: String) -> Aluno? {
        return alunosPorEmail[email]
    }

    func buscarInstrutorPorEmail(_ email: String) -> Instrutor? {
        return instrutoresPorEmail[email]
    }

    func listarAlunos() {
        print("Alunos cadastrados:")

        if alunosPorMatricula.isEmpty {
            print("Nenhum aluno cadastrado.")
            return
        }

        for aluno in alunosPorMatricula.values {
            print("- \(aluno.nome) | Matrícula: \(aluno.matricula) | Plano: \(aluno.plano.nome)")
        }
    }

    func listarInstrutores() {
        print("Instrutores cadastrados:")

        if instrutoresPorEmail.isEmpty {
            print("Nenhum instrutor cadastrado.")
            return
        }

        for instrutor in instrutoresPorEmail.values {
            print("- \(instrutor.nome) | Especialidade: \(instrutor.especialidade.rawValue)")
        }
    }

    func listarEquipamentos() {
        print("Equipamentos cadastrados:")

        if equipamentosPorNome.isEmpty {
            print("Nenhum equipamento cadastrado.")
            return
        }

        for equipamento in equipamentosPorNome.values {
            print("- \(equipamento.nomeItem) | Estado: \(equipamento.estado.rawValue)")
        }
    }

    func realizarManutencaoProgramada(data: String) -> [EquipamentoFisico] {
        var equipamentosComFalha: [EquipamentoFisico] = []

        for nomeEquipamento in equipamentosPorNome.keys {
            guard var equipamento = equipamentosPorNome[nomeEquipamento] else {
                continue
            }

            let sucesso = equipamento.realizarReparo(
                data: data,
                regular: true
            )

            equipamentosPorNome[nomeEquipamento] = equipamento

            if !sucesso {
                equipamentosComFalha.append(equipamento)
            }
        }

        return equipamentosComFalha
    }

    func reportarFalhasManutencao(_ equipamentosComFalha: [EquipamentoFisico]) {
        if equipamentosComFalha.isEmpty {
            print("Manutenção programada concluída. Nenhuma máquina falhou.")
            return
        }

        print("Máquinas que falharam na manutenção:")

        for equipamento in equipamentosComFalha {
            print("- \(equipamento.nomeItem) | Estado: \(equipamento.estado.rawValue)")
        }
    }

    @discardableResult
    func agendarPersonalTrainer(
        matriculaAluno: String,
        emailInstrutor: String,
        nomeTreino: String,
        categoria: CategoriaAula,
        descricao: String,
        objetivo: String,
        dataAgendada: String
    ) -> TreinoPersonal? {
        guard let aluno = alunosPorMatricula[matriculaAluno] else {
            print("Erro: aluno com matrícula \(matriculaAluno) não encontrado.")
            return nil
        }

        guard let instrutor = instrutoresPorEmail[emailInstrutor] else {
            print("Erro: instrutor com e-mail \(emailInstrutor) não encontrado.")
            return nil
        }

        if !aluno.plano.incluiPersonalTrainer {
            print("Erro: o plano \(aluno.plano.nome) do aluno \(aluno.nome) não autoriza personal trainer.")
            return nil
        }

        let codigoTreino = "\(matriculaAluno)-\(emailInstrutor)-\(dataAgendada)"

        if treinosPersonal[codigoTreino] != nil {
            print("Erro: já existe um treino personal agendado para esse aluno, instrutor e data.")
            return nil
        }

        let treino = TreinoPersonal(
            nome: nomeTreino,
            instrutor: instrutor,
            categoria: categoria,
            descricao: descricao,
            aluno: aluno,
            objetivo: objetivo,
            dataAgendada: dataAgendada
        )

        treinosPersonal[codigoTreino] = treino

        print("Treino personal agendado com sucesso para o aluno \(aluno.nome).")
        return treino
    }

    func listarTreinosPersonal() {
        print("Treinos com personal agendados:")

        if treinosPersonal.isEmpty {
            print("Nenhum treino personal agendado.")
            return
        }

        for treino in treinosPersonal.values {
            print("- \(treino.nome) | Aluno: \(treino.aluno.nome) | Instrutor: \(treino.instrutor.nome) | Data: \(treino.dataAgendada)")
        }
    }
}

// Métricas da Academia

struct MetricasAcademia {
    let totalAlunos: Int
    let totalInstrutores: Int
    let totalAulasAtivas: Int
    let totalEquipamentosDanificados: Int
}

// Extensão da Academia

extension Academia {
    func gerarMetricas() -> MetricasAcademia {
        let equipamentosDanificados = equipamentosPorNome.values.filter {
            $0.estado == .defeituoso
        }.count

        let totalAulas = turmasColetivas.count + treinosPersonal.count

        return MetricasAcademia(
            totalAlunos: alunosPorMatricula.count,
            totalInstrutores: instrutoresPorEmail.count,
            totalAulasAtivas: totalAulas,
            totalEquipamentosDanificados: equipamentosDanificados
        )
    }
}

// Roteiro de integração

print("====================================")
print(" SISTEMA DA ACADEMIA ")
print("====================================\n")

let academia = Academia(nome: "Academia Vida Ativa")

print("===== CATÁLOGO DE PLANOS =====")

for plano in CatalogoPlanos.todos {
    print("Plano: \(plano.nome)")
    print("Mensalidade: R$ \(plano.valorMensalidade)")
    print("Inclui personal trainer? \(plano.incluiPersonalTrainer)")
    print("Limite de aulas coletivas: \(plano.limiteAulasColetivas)")
    print("Duração: \(plano.duracaoMeses) mês(es)")
    print("----------------")
}

print("\n===== CADASTRO DE INSTRUTORES =====")

let instrutoraYoga = Instrutor(
    nome: "Raphael Martins",
    email: "raphaelnoob@email.com",
    especialidade: .yoga
)

let instrutorMusculacao = Instrutor(
    nome: "Carlos Oliveira",
    email: "carlos@email.com",
    especialidade: .musculacao
)

let instrutorLuta = Instrutor(
    nome: "Marcos Nogueira",
    email: "marcos@email.com",
    especialidade: .luta
)

academia.cadastrarInstrutor(instrutoraYoga)
academia.cadastrarInstrutor(instrutorMusculacao)
academia.cadastrarInstrutor(instrutorLuta)

print("\nTentando cadastrar instrutor com e-mail duplicado:")

let instrutorDuplicado = Instrutor(
    nome: "Outro Carlos",
    email: "carlos@email.com",
    especialidade: .funcional
)

academia.cadastrarInstrutor(instrutorDuplicado)

print("\n===== CADASTRO DE ALUNOS =====")

let aluno1 = Aluno(
    nome: "Ana Paula",
    email: "ana@email.com",
    matricula: "A001",
    plano: CatalogoPlanos.mensal,
    nivel: .iniciante
)

let aluno2 = Aluno(
    nome: "Alberto Silva Alves",
    email: "alberto@email.com",
    matricula: "A002",
    plano: CatalogoPlanos.trimestral,
    nivel: .intermediario
)

let aluno3 = Aluno(
    nome: "Carla Maria",
    email: "carla@email.com",
    matricula: "A003",
    plano: CatalogoPlanos.anual,
    nivel: .avancado
)

let aluno4 = Aluno(
    nome: "Diego Barbosa",
    email: "diego@email.com",
    matricula: "A004",
    plano: CatalogoPlanos.anual,
    nivel: .intermediario
)

academia.cadastrarAluno(aluno1)
academia.cadastrarAluno(aluno2)
academia.cadastrarAluno(aluno3)
academia.cadastrarAluno(aluno4)

print("\nTentando cadastrar aluno com matrícula duplicada:")

let alunoMatriculaDuplicada = Aluno(
    nome: "Aluno Duplicado",
    email: "duplicado@email.com",
    matricula: "A001",
    plano: CatalogoPlanos.mensal,
    nivel: .iniciante
)

academia.cadastrarAluno(alunoMatriculaDuplicada)

print("\nTentando cadastrar aluno com e-mail duplicado:")

let alunoEmailDuplicado = Aluno(
    nome: "Outro Bruno",
    email: "bruno@email.com",
    matricula: "A005",
    plano: CatalogoPlanos.mensal,
    nivel: .iniciante
)

academia.cadastrarAluno(alunoEmailDuplicado)

print("\n===== CONSULTA RÁPIDA POR MATRÍCULA =====")

if let alunoEncontrado = academia.buscarAlunoPorMatricula("A003") {
    print("Aluno encontrado:")
    alunoEncontrado.descrever()
}

print("\n===== ATUALIZAÇÃO DE ALUNO =====")

print("Antes da atualização:")
aluno1.descrever()

aluno1.atualizarPlano(CatalogoPlanos.anual)
aluno1.atualizarNivel(.intermediario)

print("\nDepois da atualização:")
aluno1.descrever()

print("\n===== CADASTRO DE EQUIPAMENTOS =====")

let esteira = EquipamentoFisico(
    nomeItem: "Esteira Elétrica",
    estado: .funcionando
)

let bicicleta = EquipamentoFisico(
    nomeItem: "Bicicleta Ergométrica",
    estado: .defeituoso
)

let legPress = EquipamentoFisico(
    nomeItem: "Leg Press",
    estado: .funcionando
)

let sacoDePancada = EquipamentoFisico(
    nomeItem: "Saco de Pancada",
    estado: .defeituoso
)

academia.cadastrarEquipamento(esteira)
academia.cadastrarEquipamento(bicicleta)
academia.cadastrarEquipamento(legPress)
academia.cadastrarEquipamento(sacoDePancada)

print("\n===== MANUTENÇÃO PROGRAMADA EM LOTE =====")

let equipamentosComFalha = academia.realizarManutencaoProgramada(
    data: "01/05/2026"
)

academia.reportarFalhasManutencao(equipamentosComFalha)

print("\n===== CADASTRO E TESTE DE TURMAS COLETIVAS =====")

let turmaYoga = TurmaColetiva(
    nome: "Yoga Matinal",
    instrutor: instrutoraYoga,
    categoria: .yoga,
    descricao: "Aula coletiva de yoga para respiração, flexibilidade e equilíbrio.",
    capacidadeMaxima: 2,
    capacidadeMinima: 1
)

let turmaLuta = TurmaColetiva(
    nome: "Luta Funcional",
    instrutor: instrutorLuta,
    categoria: .luta,
    descricao: "Aula coletiva de luta com condicionamento físico.",
    capacidadeMaxima: 3,
    capacidadeMinima: 2
)

academia.cadastrarTurmaColetiva(turmaYoga)
academia.cadastrarTurmaColetiva(turmaLuta)

print("\nTentando inscrever Ana na Yoga:")
turmaYoga.inscreverAluno(aluno1)

print("\nTentando inscrever Bruno na Yoga:")
turmaYoga.inscreverAluno(aluno2)

print("\nTentando inscrever Ana novamente na Yoga:")
turmaYoga.inscreverAluno(aluno1)

print("\nTentando inscrever Carla na Yoga, mas a turma já está cheia:")
turmaYoga.inscreverAluno(aluno3)

print("\nLista final de inscritos na Yoga:")
turmaYoga.listarInscritos()

print("\nA turma Yoga atingiu o mínimo?")
print(turmaYoga.possuiQuantidadeMinima())

print("\nInscrevendo alunos na turma de Luta:")
turmaLuta.inscreverAluno(aluno2)
turmaLuta.inscreverAluno(aluno3)
turmaLuta.inscreverAluno(aluno4)

print("\nLista final de inscritos na Luta:")
turmaLuta.listarInscritos()

print("\n===== AGENDAMENTO DE PERSONAL TRAINER =====")

print("Tentando agendar personal para Bruno, que possui plano Trimestral sem personal:")

academia.agendarPersonalTrainer(
    matriculaAluno: "A002",
    emailInstrutor: "carlos@email.com",
    nomeTreino: "Treino de Força Individual",
    categoria: .musculacao,
    descricao: "Treino individual focado em força e condicionamento físico.",
    objetivo: "Ganhar força muscular",
    dataAgendada: "02/05/2026"
)

print("\nTentando agendar personal para Carla, que possui plano Anual com personal:")

let treinoCarla = academia.agendarPersonalTrainer(
    matriculaAluno: "A003",
    emailInstrutor: "carlos@email.com",
    nomeTreino: "Treino Avançado de Musculação",
    categoria: .musculacao,
    descricao: "Treino personalizado para aumento de força e hipertrofia.",
    objetivo: "Aumentar força e resistência muscular",
    dataAgendada: "03/05/2026"
)

if let treino = treinoCarla {
    print("\nDetalhes do treino agendado:")
    treino.descreverTreino()
}

print("\nTentando agendar personal para Diego:")

let treinoDiego = academia.agendarPersonalTrainer(
    matriculaAluno: "A004",
    emailInstrutor: "marcos@email.com",
    nomeTreino: "Personal de Luta",
    categoria: .luta,
    descricao: "Treino individual com foco em técnica e condicionamento.",
    objetivo: "Melhorar resistência e técnica de luta",
    dataAgendada: "04/05/2026"
)

print("\nTentando agendar personal novamente no mesmo dia para Carla:")

academia.agendarPersonalTrainer(
    matriculaAluno: "A003",
    emailInstrutor: "carlos@email.com",
    nomeTreino: "Treino Repetido",
    categoria: .musculacao,
    descricao: "Tentativa de agendamento duplicado.",
    objetivo: "Teste de duplicidade",
    dataAgendada: "03/05/2026"
)

print("\n===== POLIMORFISMO COM PESSOAS =====")

let pessoas: [Pessoa] = [
    aluno1,
    aluno2,
    aluno3,
    aluno4,
    instrutoraYoga,
    instrutorMusculacao,
    instrutorLuta
]

for pessoa in pessoas {
    pessoa.descrever()
    print("----------------")
}

print("\n===== POLIMORFISMO COM AULAS =====")

var aulas: [Aula] = [
    turmaYoga,
    turmaLuta
]

if let treinoCarla = treinoCarla {
    aulas.append(treinoCarla)
}

if let treinoDiego = treinoDiego {
    aulas.append(treinoDiego)
}

for aula in aulas {
    print("Aula: \(aula.nome)")
    print("Instrutor: \(aula.instrutor.nome)")
    print("Categoria: \(aula.categoria.rawValue)")
    print("Descrição: \(aula.descricao)")
    print("----------------")
}

print("\n===== MÉTRICAS DA ACADEMIA =====")

let metricas = academia.gerarMetricas()

print("Total de alunos: \(metricas.totalAlunos)")
print("Total de instrutores: \(metricas.totalInstrutores)")
print("Total de aulas ativas: \(metricas.totalAulasAtivas)")
print("Total de equipamentos danificados: \(metricas.totalEquipamentosDanificados)")

print("\n===== LISTAGENS FINAIS =====")

academia.listarAlunos()
print("----------------")
academia.listarInstrutores()
print("----------------")
academia.listarEquipamentos()
print("----------------")
academia.listarTreinosPersonal()

print("\n====================================")
print(" FIM DOS TESTES")
print("====================================")