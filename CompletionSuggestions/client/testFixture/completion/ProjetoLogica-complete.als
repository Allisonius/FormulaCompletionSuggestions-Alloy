open util/ordering [Time]

module AssistenciaHospitalar

sig Time{}

one sig Servidor{
	gerentes: some Medico,
	plataformaServidor: one Linux,
	suporte: one Suporte,
	pacientesCadastrados: set Paciente,
	medicos: set Medico
}

sig Paciente{
	data: one DataDeNascimento,
	nomePaciente: one Nome,
	sintomas: Sintoma -> Time,
	emailPaciente: one Email,
	loginPaciente: one Login,
	senhaPaciente: one Senha,
	sistemaPaciente: one SistemaCliente,
	statusPaciente: StatusCadastro one -> Time
}

sig Medico{
	pacientes: Paciente -> Time,
	senhaMedico: one Senha,
	nomeMedico: one Nome,
	emailMedico: one Email,
	loginMedico: one Login,
	statusMedico:  StatusCadastro one -> Time
}

sig SistemaCliente{
	internet: one StatusInternet,
	plataforma: one SistemaOperacional
}

one sig Suporte{
	statusDoSuporte: StatusAcionado one -> Time
}

abstract sig StatusAcionado{}

sig SuporteAcionado, SuporteNaoAcionado extends StatusAcionado{}

abstract sig StatusCadastro{}

sig Cadastrado, NaoCadastrado extends StatusCadastro{}

abstract sig StatusInternet{}

sig ComInternet, SemInternet extends StatusInternet{}

abstract sig SistemaOperacional{}

one	sig Linux extends SistemaOperacional{}

sig Senha{}

sig Login{}

sig Nome{}	

sig Email{}

sig DataDeNascimento{}

sig Sintoma{}

fun pacientesNoServidor[s: Servidor]: set Paciente{
	s.pacientesCadastrados
} 

fun medicosNoServidor[s: Servidor]: set Medico{
	s.medicos
}

fun todosOsNomes[p: Paciente, m: Medico]: set Nome{
	 p.nomePaciente + m.nomeMedico
}

pred verificaRelacaoMedicosEPacientesCadastrados{
	all p1:Paciente, m1:Medico, t: Time |  p1 in m1.pacientes.t => p1.statusPaciente.t = Cadastrado
	all m1:Medico, t: Time | m1.statusMedico.t = NaoCadastrado => #m1.pacientes = 0
}

pred verificaGerenteCadastrado{
	all m1:Medico, s1:Servidor, t: Time | m1 in s1.gerentes  => m1.statusMedico.t = Cadastrado
}

pred cadaMedicoTemDe1a3Pacientes{
	all m1:Medico | #m1.pacientes < 4
}

pred todoSistemaClienteEstaEmPaciente{
	all s:SistemaCliente, p:Paciente | s in p.sistemaPaciente
}

pred oSistemaTem2GerentesDiferentes{
	all s1:Servidor | #s1.gerentes = 2
	all g1:Servidor.gerentes, g2: Servidor.gerentes - g1 | g1 != g2
}

pred loginsDevemSerDiferentes{
	all p1:Paciente, p2:Paciente-p1 | p1.loginPaciente != p2.loginPaciente
	all m1:Medico, m2:Medico-m1 | m1.loginMedico != m2.loginMedico
	all m1:Medico, p1:Paciente| m1.loginMedico != p1.loginPaciente
}

pred emailsDevemSerDiferentes{
	all p1:Paciente, p2:Paciente-p1 | p1.emailPaciente != p2.emailPaciente
	all m1:Medico, m2:Medico-m1 | m1.emailMedico != m2.emailMedico
	all m1:Medico, p1:Paciente| m1.emailMedico != p1.emailPaciente
}

pred pacientesEMedicosDevemEstarNoServidor{
	all p1:Paciente |  p1 in pacientesNoServidor[Servidor]
	all m: Medico | m in medicosNoServidor[Servidor]
}

pred qualquerDadoPertenceAalguem{
	all n:Nome | n in todosOsNomes[Paciente, Medico]
	all l:Login | l in Paciente.loginPaciente + Medico.loginMedico
	all e:Email | e in Paciente.emailPaciente + Medico.emailMedico
	all s:Senha | s in Paciente.senhaPaciente + Medico.senhaMedico
	all d:DataDeNascimento | d in Paciente.data
}

pred init[t: Time]{
}

pred acionaSuporte[t, tt : Time, su: Suporte ]{
	su.statusDoSuporte.t in SuporteNaoAcionado
	su.statusDoSuporte.tt = SuporteAcionado
}

pred cadastrarPaciente[t, tt : Time, p:Paciente, m:Medico ]{
	p.statusPaciente.t in NaoCadastrado
	p.statusPaciente.tt = Cadastrado
}

pred cadastrarMedico[t, tt : Time, m:Medico ]{
	m.statusMedico.t in NaoCadastrado
	m.statusMedico.tt = Cadastrado
}

pred alocaPaciente[t, tt : Time, p: Paciente, m: Medico]{
	p.statusPaciente.t in Cadastrado
	p not in Medico.pacientes.t
	m.pacientes.tt = m.pacientes.t + p
}

pred cadastrarSintoma[t,tt : Time, p: Paciente, si: Sintoma]{
	p.statusPaciente.t in Cadastrado
	si not in p.sintomas.t
	p.sintomas.tt = p.sintomas.t + si
}

pred show{}

fact EspecificacaoDoSistema{
	verificaRelacaoMedicosEPacientesCadastrados
	cadaMedicoTemDe1a3Pacientes
	oSistemaTem2GerentesDiferentes
	pacientesEMedicosDevemEstarNoServidor
	verificaGerenteCadastrado
	loginsDevemSerDiferentes
	emailsDevemSerDiferentes
	todoSistemaClienteEstaEmPaciente
	qualquerDadoPertenceAalguem	
}

fact traces {
	init [first]
	all pre: Time - last | let pos = pre.next |
	some  p: Paciente, m: Medico, si: Sintoma, su: Suporte |
	cadastrarMedico[pre,pos,m] and
	acionaSuporte[pre, pos, su] or
	cadastrarPaciente[pre,pos,p,m] or 
	alocaPaciente[pre,pos,p, m] or 
	cadastrarSintoma[pre,pos,p, si]
	
}

fact fatosMedicos{
	all m: Medico, t: Time| m.pacientes.t.statusPaciente.t in Cadastrado
}

fact fatosPaciente{
	all p: Paciente, sv: Servidor, t: Time | p in sv.pacientesCadastrados => p.statusPaciente.t in Cadastrado
}

fact fatosSintomas{
	all p: Paciente, t: Time | p.statusPaciente.t in NaoCadastrado =>  #p.sintomas.t  = 0
	all si: Sintoma,  p: Paciente, t: Time | si in p.sintomas.t
}

fact fatosStatusCadastro{
	all p: Paciente, m : Medico, st: StatusCadastro, t : Time | st in p.statusPaciente.t or st in m.statusMedico.t
}

fact fatosStatusInternet{
	all s: SistemaCliente, st: StatusInternet | st in s.internet
}

fact fatosStatusAcionado{
	all su: Suporte, st: StatusAcionado, t: Time | st in su.statusDoSuporte.t
}

assert medicosAtendemDe1a3pacientes {
	all m: Medico | #m.pacientes < 3
}

assert servidorPossuiApenas2Gerentes{
	all s: Servidor | #s.gerentes = 2
}

assert pacienteCadastradoContemTodosOsDados{
	all p: Paciente, t : Time |
	p.statusPaciente.t = Cadastrado
	implies
		#p.nomePaciente != 0 and
		#p.loginPaciente != 0 and
		#p.emailPaciente != 0 and
		#p.data != 0 and
		#p.senhaPaciente != 0 and
		#p.sistemaPaciente != 0 and
	
	all p: Paciente, t: Time |
	p.statusPaciente.t = NaoCadastrado
	implies
		#p.nomePaciente = 0 and
		#p.loginPaciente = 0 and
		#p.emailPaciente = 0 and
		#p.data = 0 and
		#p.senhaPaciente = 0 and
		#p.sistemaPaciente = 0 and
		#p.sintomas = 0
}

assert medicoCadastradoContemTodosOsDados{
	all m: Medico, t: Time | m.statusMedico.t = Cadastrado
		implies
			#m.nomeMedico != 0 and
			#m.loginMedico != 0 and
			#m.emailMedico != 0 and
			#m.senhaMedico != 0
	
	all m: Medico, t: Time | m.statusMedico.t = NaoCadastrado
		implies
			#m.nomeMedico = 0 and
			#m.loginMedico = 0 and
			#m.emailMedico = 0 and
			#m.senhaMedico = 0
}

assert todosOsDadosPossuemDono{
	all n: Nome, s: Senha, l: Login, d: DataDeNascimento, e: Email, p: Paciente, m: Medico | 
		(n in p.nomePaciente) or (n in m.nomeMedico) and
		(s in p.senhaPaciente) or (s in m.senhaMedico) and
		(l in p.loginPaciente) or (l in m.loginMedico) and
		(d in p.data) and
		(e in p.emailPaciente) or (e in m.emailMedico)
} 

assert servidorPossuiApenas1Suporte{
	all s: Servidor | #s.suporte = 1
}

assert plataformaDoServidorDeveSerLinux{
	all s: Servidor | s.plataformaServidor = Linux
}

run show for 10
