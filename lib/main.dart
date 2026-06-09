
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<Map<String, Object>> bancosDisponiblesTc = [
  {'nombre': 'BCP', 'color': Color(0xFFFF7A00)},
  {'nombre': 'BBVA', 'color': Color(0xFF004481)},
  {'nombre': 'INTERBANK', 'color': Color(0xFF00A94F)},
  {'nombre': 'SCOTIABANK', 'color': Color(0xFFE30613)},
];

const List<String> entidadesPrestamo = [
  'YAPE',
  'BCP',
  'BBVA',
  'INTERBANK',
  'SCOTIABANK',
  'CAJA AREQUIPA',
  'CAJA HUANCAYO',
  'CAJA CUZCO',
  'FINANCIERA EFECTIVA',
  'MI BANCO',
  'OTRO',
];


const List<String> categoriasBase = [
  'Consumo',
  'Transporte',
  'Compras',
  'Ocio',
  'Otros',
];

const Map<String, String> iconosCategoria = {
  'Consumo': '🍔',
  'Transporte': '🚕',
  'Compras': '🛒',
  'Ocio': '🎉',
  'Otros': '📦',
};

void main() {
  runApp(const MiDisponibleApp());
}

class MiDisponibleApp extends StatelessWidget {
  const MiDisponibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Disponible',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF5A55F2),
        scaffoldBackgroundColor: const Color(0xFFF6F5FF),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F5FF),
          foregroundColor: Color(0xFF111827),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF111827),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
          iconTheme: IconThemeData(
            color: Color(0xFF111827),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
      ),
      home: const InicioScreen(),
    );
  }
}

// ===================== MODELOS =====================

class Gasto {
  final String id;
  final double monto;
  final String categoria;
  final String medioPago;
  final DateTime fecha;
  final String? bancoTarjeta;

  Gasto({
    required this.id,
    required this.monto,
    required this.categoria,
    required this.medioPago,
    required this.fecha,
    this.bancoTarjeta,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'monto': monto,
        'categoria': categoria,
        'medioPago': medioPago,
        'fecha': fecha.toIso8601String(),
        'bancoTarjeta': bancoTarjeta,
      };

  factory Gasto.fromJson(Map<String, dynamic> json) => Gasto(
        id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
        monto: (json['monto'] as num).toDouble(),
        categoria: json['categoria'],
        medioPago: json['medioPago'],
        fecha: DateTime.parse(json['fecha']),
        bancoTarjeta: json['bancoTarjeta'],
      );
}

class Ingreso {
  final String id;
  final double monto;
  final String tipo;
  final DateTime fecha;

  Ingreso({
    required this.id,
    required this.monto,
    required this.tipo,
    required this.fecha,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'monto': monto,
        'tipo': tipo,
        'fecha': fecha.toIso8601String(),
      };

  factory Ingreso.fromJson(Map<String, dynamic> json) => Ingreso(
        id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
        monto: (json['monto'] as num).toDouble(),
        tipo: json['tipo'],
        fecha: DateTime.parse(json['fecha']),
      );
}

class TarjetaCredito {
  final String id;
  final String banco;
  final double lineaCredito;
  final int diaFacturacion;
  final int diaPago;

  TarjetaCredito({
    required this.id,
    required this.banco,
    required this.lineaCredito,
    required this.diaFacturacion,
    required this.diaPago,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'banco': banco,
        'lineaCredito': lineaCredito,
        'diaFacturacion': diaFacturacion,
        'diaPago': diaPago,
      };

  factory TarjetaCredito.fromJson(Map<String, dynamic> json) => TarjetaCredito(
        id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
        banco: json['banco'],
        lineaCredito: (json['lineaCredito'] as num?)?.toDouble() ?? 0,
        diaFacturacion: json['diaFacturacion'],
        diaPago: json['diaPago'],
      );
}

class PagoTarjeta {
  final String id;
  final String banco;
  final double monto;
  final DateTime fecha;

  PagoTarjeta({
    required this.id,
    required this.banco,
    required this.monto,
    required this.fecha,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'banco': banco,
        'monto': monto,
        'fecha': fecha.toIso8601String(),
      };

  factory PagoTarjeta.fromJson(Map<String, dynamic> json) => PagoTarjeta(
        id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
        banco: json['banco'],
        monto: (json['monto'] as num).toDouble(),
        fecha: DateTime.parse(json['fecha']),
      );
}

class Ruleteo {
  final String id;
  final String bancoOrigen;
  final String bancoDestino;
  final double monto;
  final double comision;
  final DateTime fecha;

  Ruleteo({
    required this.id,
    required this.bancoOrigen,
    required this.bancoDestino,
    required this.monto,
    required this.comision,
    required this.fecha,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'bancoOrigen': bancoOrigen,
        'bancoDestino': bancoDestino,
        'monto': monto,
        'comision': comision,
        'fecha': fecha.toIso8601String(),
      };

  factory Ruleteo.fromJson(Map<String, dynamic> json) => Ruleteo(
        id: json['id'],
        bancoOrigen: json['bancoOrigen'],
        bancoDestino: json['bancoDestino'],
        monto: (json['monto'] as num).toDouble(),
        comision: (json['comision'] as num).toDouble(),
        fecha: DateTime.parse(json['fecha']),
      );
}

class Prestamo {
  final String id;
  final String entidad;
  final double capitalInicial;
  final double cuotaMensual;
  final int plazoMeses;
  final int diaPago;
  final double tasaMensual;
  final DateTime fechaInicio;

  Prestamo({
    required this.id,
    required this.entidad,
    required this.capitalInicial,
    required this.cuotaMensual,
    required this.plazoMeses,
    required this.diaPago,
    required this.tasaMensual,
    required this.fechaInicio,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'entidad': entidad,
        'capitalInicial': capitalInicial,
        'cuotaMensual': cuotaMensual,
        'plazoMeses': plazoMeses,
        'diaPago': diaPago,
        'tasaMensual': tasaMensual,
        'fechaInicio': fechaInicio.toIso8601String(),
      };

  factory Prestamo.fromJson(Map<String, dynamic> json) => Prestamo(
        id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
        entidad: json['entidad'],
        capitalInicial: (json['capitalInicial'] as num).toDouble(),
        cuotaMensual: (json['cuotaMensual'] as num).toDouble(),
        plazoMeses: json['plazoMeses'],
        diaPago: json['diaPago'],
        tasaMensual: (json['tasaMensual'] as num).toDouble(),
        fechaInicio: DateTime.parse(json['fechaInicio']),
      );
}

class PagoPrestamo {
  final String id;
  final String prestamoId;
  final String tipo; // CUOTA o CAPITAL
  final double monto;
  final double interes;
  final double capital;
  final int? numeroCuota;
  final DateTime fecha;

  PagoPrestamo({
    required this.id,
    required this.prestamoId,
    required this.tipo,
    required this.monto,
    required this.interes,
    required this.capital,
    required this.fecha,
    this.numeroCuota,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'prestamoId': prestamoId,
        'tipo': tipo,
        'monto': monto,
        'interes': interes,
        'capital': capital,
        'numeroCuota': numeroCuota,
        'fecha': fecha.toIso8601String(),
      };

  factory PagoPrestamo.fromJson(Map<String, dynamic> json) => PagoPrestamo(
        id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
        prestamoId: json['prestamoId'],
        tipo: json['tipo'],
        monto: (json['monto'] as num).toDouble(),
        interes: (json['interes'] as num).toDouble(),
        capital: (json['capital'] as num).toDouble(),
        numeroCuota: json['numeroCuota'],
        fecha: DateTime.parse(json['fecha']),
      );
}



class MetaAhorro {
  final String id;
  final String nombre;
  final double montoMeta;
  final double montoActual;
  final DateTime fechaCreacion;

  MetaAhorro({
    required this.id,
    required this.nombre,
    required this.montoMeta,
    required this.montoActual,
    required this.fechaCreacion,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'montoMeta': montoMeta,
        'montoActual': montoActual,
        'fechaCreacion': fechaCreacion.toIso8601String(),
      };

  factory MetaAhorro.fromJson(Map<String, dynamic> json) => MetaAhorro(
        id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
        nombre: json['nombre'] ?? 'Meta',
        montoMeta: (json['montoMeta'] as num?)?.toDouble() ?? 0,
        montoActual: (json['montoActual'] as num?)?.toDouble() ?? 0,
        fechaCreacion: json['fechaCreacion'] == null
            ? DateTime.now()
            : DateTime.parse(json['fechaCreacion']),
      );
}


class PresupuestoCategoria {
  final String categoria;
  final double montoMensual;

  PresupuestoCategoria({
    required this.categoria,
    required this.montoMensual,
  });

  Map<String, dynamic> toJson() => {
        'categoria': categoria,
        'montoMensual': montoMensual,
      };

  factory PresupuestoCategoria.fromJson(Map<String, dynamic> json) =>
      PresupuestoCategoria(
        categoria: json['categoria'] ?? 'Otros',
        montoMensual: (json['montoMensual'] as num?)?.toDouble() ?? 0,
      );
}

class FilaCronograma {
  final int numero;
  final DateTime fecha;
  final double cuota;
  final double interes;
  final double capital;
  final double saldo;
  final bool pagado;

  FilaCronograma({
    required this.numero,
    required this.fecha,
    required this.cuota,
    required this.interes,
    required this.capital,
    required this.saldo,
    required this.pagado,
  });
}

// ===================== HELPERS =====================

Color colorBanco(String banco) {
  final item = bancosDisponiblesTc.firstWhere(
    (b) => b['nombre'] == banco,
    orElse: () => {'nombre': banco, 'color': Colors.grey},
  );
  return item['color'] as Color;
}

Color colorEntidad(String entidad) {
  final normal = entidad.toUpperCase();
  if (normal.contains('BCP')) return const Color(0xFFFF7A00);
  if (normal.contains('BBVA')) return const Color(0xFF004481);
  if (normal.contains('INTERBANK')) return const Color(0xFF00A94F);
  if (normal.contains('SCOTIABANK')) return const Color(0xFFE30613);
  if (normal.contains('YAPE')) return const Color(0xFF742384);
  if (normal.contains('HUANCAYO')) return const Color(0xFF0B5D3B);
  if (normal.contains('AREQUIPA')) return const Color(0xFF1565C0);
  if (normal.contains('CUZCO')) return const Color(0xFFD97706);
  return const Color(0xFF455A64);
}

DateTime fechaPagoDesdeInicio(DateTime primeraCuota, int diaPago, int numero) {
  final base = DateTime(primeraCuota.year, primeraCuota.month + numero - 1, 1);
  final ultimoDia = DateTime(base.year, base.month + 1, 0).day;
  final dia = diaPago.clamp(1, ultimoDia);
  return DateTime(base.year, base.month, dia);
}

String formatoFecha(DateTime fecha) {
  final d = fecha.day.toString().padLeft(2, '0');
  final m = fecha.month.toString().padLeft(2, '0');
  return '$d/$m/${fecha.year}';
}

DateTime? parseFechaManual(String texto) {
  final limpio = texto.trim();
  if (limpio.isEmpty) return null;
  final partes = limpio.split('/');
  if (partes.length != 3) return null;
  final dia = int.tryParse(partes[0]);
  final mes = int.tryParse(partes[1]);
  final anio = int.tryParse(partes[2]);
  if (dia == null || mes == null || anio == null) return null;
  if (mes < 1 || mes > 12) return null;
  final ultimo = DateTime(anio, mes + 1, 0).day;
  if (dia < 1 || dia > ultimo) return null;
  return DateTime(anio, mes, dia);
}

int diasHasta(DateTime fecha) {
  final hoy = DateTime.now();
  final baseHoy = DateTime(hoy.year, hoy.month, hoy.day);
  final baseFecha = DateTime(fecha.year, fecha.month, fecha.day);
  return baseFecha.difference(baseHoy).inDays;
}

DateTime proximaFechaMensual(int dia, {DateTime? desde}) {
  final hoy = desde ?? DateTime.now();
  var candidata = DateTime(hoy.year, hoy.month, 1);
  int ultimo = DateTime(candidata.year, candidata.month + 1, 0).day;
  candidata = DateTime(candidata.year, candidata.month, dia.clamp(1, ultimo));
  if (candidata.isBefore(DateTime(hoy.year, hoy.month, hoy.day))) {
    final siguiente = DateTime(hoy.year, hoy.month + 1, 1);
    ultimo = DateTime(siguiente.year, siguiente.month + 1, 0).day;
    candidata = DateTime(siguiente.year, siguiente.month, dia.clamp(1, ultimo));
  }
  return candidata;
}

double redondear(double n) => double.parse(n.toStringAsFixed(2));

// ===================== INICIO =====================

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final List<Gasto> gastos = [];
  final List<Ingreso> ingresos = [];
  final List<TarjetaCredito> tarjetas = [];
  final List<PagoTarjeta> pagosTarjeta = [];
  final List<Ruleteo> ruleteos = [];
  final List<Prestamo> prestamos = [];
  final List<PagoPrestamo> pagosPrestamo = [];
  final List<MetaAhorro> metasAhorro = [];
  final List<PresupuestoCategoria> presupuestosCategoria = [];

  int frecuenciaSueldo = 30;
  DateTime? fechaUltimoSueldo;
  double ahorroAcumulado = 0;
  String nombreUsuario = '';
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();

    final gastosTexto = prefs.getString('gastos');
    final ingresosTexto = prefs.getString('ingresos');
    final fechaTexto = prefs.getString('fechaUltimoSueldo');
    final tarjetasTexto = prefs.getString('tarjetas');
    final pagosTexto = prefs.getString('pagosTarjeta');
    final ruleteosTexto = prefs.getString('ruleteos');
    final prestamosTexto = prefs.getString('prestamos');
    final pagosPrestamoTexto = prefs.getString('pagosPrestamo');
    final metasTexto = prefs.getString('metasAhorro');
    final presupuestosTexto = prefs.getString('presupuestosCategoria');
    final nombreTexto = prefs.getString('nombreUsuario');

    if (gastosTexto != null) {
      final lista = jsonDecode(gastosTexto) as List;
      gastos.addAll(lista.map((e) => Gasto.fromJson(e)));
    }

    if (ingresosTexto != null) {
      final lista = jsonDecode(ingresosTexto) as List;
      ingresos.addAll(lista.map((e) => Ingreso.fromJson(e)));
    }

    if (fechaTexto != null) {
      fechaUltimoSueldo = DateTime.parse(fechaTexto);
    }

    if (tarjetasTexto != null) {
      final lista = jsonDecode(tarjetasTexto) as List;
      tarjetas.addAll(lista.map((e) => TarjetaCredito.fromJson(e)));
    }

    if (pagosTexto != null) {
      final lista = jsonDecode(pagosTexto) as List;
      pagosTarjeta.addAll(lista.map((e) => PagoTarjeta.fromJson(e)));
    }

    if (ruleteosTexto != null) {
      final lista = jsonDecode(ruleteosTexto) as List;
      ruleteos.addAll(lista.map((e) => Ruleteo.fromJson(e)));
    }

    if (prestamosTexto != null) {
      final lista = jsonDecode(prestamosTexto) as List;
      prestamos.addAll(lista.map((e) => Prestamo.fromJson(e)));
    }

    if (pagosPrestamoTexto != null) {
      final lista = jsonDecode(pagosPrestamoTexto) as List;
      pagosPrestamo.addAll(lista.map((e) => PagoPrestamo.fromJson(e)));
    }



    if (metasTexto != null) {
      final lista = jsonDecode(metasTexto) as List;
      metasAhorro.addAll(lista.map((e) => MetaAhorro.fromJson(e)));
    }


    if (presupuestosTexto != null) {
      final lista = jsonDecode(presupuestosTexto) as List;
      presupuestosCategoria.addAll(
        lista.map((e) => PresupuestoCategoria.fromJson(e)),
      );
    }

    ahorroAcumulado = prefs.getDouble('ahorroAcumulado') ?? 0;
    nombreUsuario = nombreTexto ?? '';
    frecuenciaSueldo = prefs.getInt('frecuenciaSueldo') ?? 30;

    setState(() {
      cargando = false;
    });

    if (nombreUsuario.trim().isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pedirNombreUsuario(obligatorio: true);
      });
    }
  }

  Future<void> guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'gastos',
      jsonEncode(gastos.map((g) => g.toJson()).toList()),
    );

    await prefs.setString(
      'ingresos',
      jsonEncode(ingresos.map((i) => i.toJson()).toList()),
    );

    await prefs.setString(
      'tarjetas',
      jsonEncode(tarjetas.map((t) => t.toJson()).toList()),
    );

    await prefs.setString(
      'pagosTarjeta',
      jsonEncode(pagosTarjeta.map((p) => p.toJson()).toList()),
    );

    await prefs.setString(
      'ruleteos',
      jsonEncode(ruleteos.map((r) => r.toJson()).toList()),
    );

    await prefs.setString(
      'prestamos',
      jsonEncode(prestamos.map((p) => p.toJson()).toList()),
    );

    await prefs.setString(
      'pagosPrestamo',
      jsonEncode(pagosPrestamo.map((p) => p.toJson()).toList()),
    );



    await prefs.setString(
      'metasAhorro',
      jsonEncode(metasAhorro.map((m) => m.toJson()).toList()),
    );


    await prefs.setString(
      'presupuestosCategoria',
      jsonEncode(presupuestosCategoria.map((p) => p.toJson()).toList()),
    );

    if (fechaUltimoSueldo != null) {
      await prefs.setString(
        'fechaUltimoSueldo',
        fechaUltimoSueldo!.toIso8601String(),
      );
    }

    await prefs.setDouble('ahorroAcumulado', ahorroAcumulado);
    await prefs.setString('nombreUsuario', nombreUsuario);
    await prefs.setInt('frecuenciaSueldo', frecuenciaSueldo);
  }

  double get totalIngresos =>
      ingresos.fold(0.0, (suma, i) => suma + i.monto);

  double get totalGastosDirectos {
    return gastos
        .where((g) => g.medioPago != 'Tarjeta')
        .fold(0.0, (suma, g) => suma + g.monto);
  }

  double get totalComprasTarjeta {
    return gastos
        .where((g) => g.medioPago == 'Tarjeta')
        .fold(0.0, (suma, g) => suma + g.monto);
  }

  double consumoTarjetaPorBanco(String banco) {
    final compras = gastos
        .where((g) => g.medioPago == 'Tarjeta' && g.bancoTarjeta == banco)
        .fold(0.0, (suma, g) => suma + g.monto);

    final ruleteoOrigen = ruleteos
        .where((r) => r.bancoOrigen == banco)
        .fold(0.0, (suma, r) => suma + r.monto);

    return compras + ruleteoOrigen;
  }

  double pagosTarjetaPorBanco(String banco) {
    final pagos = pagosTarjeta
        .where((p) => p.banco == banco)
        .fold(0.0, (suma, p) => suma + p.monto);

    final ruleteoDestino = ruleteos
        .where((r) => r.bancoDestino == banco)
        .fold(0.0, (suma, r) => suma + r.monto);

    return pagos + ruleteoDestino;
  }

  double deudaTarjetaPorBanco(String banco) {
    final deuda = consumoTarjetaPorBanco(banco) - pagosTarjetaPorBanco(banco);
    return deuda < 0 ? 0 : deuda;
  }

  double get totalTarjetasPendientes {
    return tarjetas.fold(
      0.0,
      (suma, t) => suma + deudaTarjetaPorBanco(t.banco),
    );
  }

  double get totalComisionRuleteo {
    return ruleteos.fold(0.0, (suma, r) => suma + r.comision);
  }

  double get totalPagosPrestamo {
    return pagosPrestamo.fold(0.0, (suma, p) => suma + p.monto);
  }

  double capitalPendientePrestamo(Prestamo p) {
    final capitalPagado = pagosPrestamo
        .where((x) => x.prestamoId == p.id)
        .fold(0.0, (suma, x) => suma + x.capital);
    final saldo = p.capitalInicial - capitalPagado;
    return saldo < 0 ? 0 : saldo;
  }

  double get totalCapitalPrestamos {
    return prestamos.fold(0.0, (suma, p) => suma + capitalPendientePrestamo(p));
  }


  double get totalMetasAsignado {
    return metasAhorro.fold(0.0, (suma, m) => suma + m.montoActual);
  }

  double get ahorroLibre {
    final libre = ahorroAcumulado - totalMetasAsignado;
    return libre < 0 ? 0 : libre;
  }

  double get totalDeudaGeneral {
    return totalTarjetasPendientes + totalCapitalPrestamos;
  }

  double gastoPromedioUltimos30Dias() {
    final limite = DateTime.now().subtract(const Duration(days: 30));
    final gastos30 = gastos
        .where((g) => g.fecha.isAfter(limite))
        .fold(0.0, (suma, g) => suma + g.monto);
    final prestamos30 = pagosPrestamo
        .where((p) => p.fecha.isAfter(limite))
        .fold(0.0, (suma, p) => suma + p.monto);
    final ruleteos30 = ruleteos
        .where((r) => r.fecha.isAfter(limite))
        .fold(0.0, (suma, r) => suma + r.comision);
    return (gastos30 + prestamos30 + ruleteos30) / 30;
  }

  int scoreFinanciero() {
    int score = 100;
    if (disponibleReal < 0) score -= 25;
    if (puedesGastarHoy < 20) score -= 10;
    if (ahorroAcumulado <= 0) score -= 15;
    if (ahorroAcumulado > 0 && ahorroAcumulado < gastoPromedioUltimos30Dias() * 7) score -= 8;
    if (totalIngresos > 0) {
      final deudaVsIngreso = totalDeudaGeneral / totalIngresos;
      if (deudaVsIngreso > 3) score -= 20;
      if (deudaVsIngreso > 1.5) score -= 10;
    }
    if (totalTarjetasPendientes > totalIngresos && totalIngresos > 0) score -= 10;
    if (obligacionesProximas().length >= 3) score -= 5;
    return score.clamp(0, 100);
  }

  String etiquetaScore() {
    final score = scoreFinanciero();
    if (score >= 85) return 'Excelente';
    if (score >= 70) return 'Bueno';
    if (score >= 50) return 'Regular';
    return 'Alerta';
  }

  double get disponibleReal {
    return totalIngresos -
        totalGastosDirectos -
        totalComprasTarjeta -
        totalComisionRuleteo -
        totalPagosPrestamo;
  }

  double get gastadoHoy {
    final hoy = DateTime.now();

    final gastosHoy = gastos
        .where((g) =>
            g.fecha.year == hoy.year &&
            g.fecha.month == hoy.month &&
            g.fecha.day == hoy.day)
        .fold(0.0, (suma, g) => suma + g.monto);

    final prestamosHoy = pagosPrestamo
        .where((p) =>
            p.fecha.year == hoy.year &&
            p.fecha.month == hoy.month &&
            p.fecha.day == hoy.day)
        .fold(0.0, (suma, p) => suma + p.monto);

    final ruleteoHoy = ruleteos
        .where((r) =>
            r.fecha.year == hoy.year &&
            r.fecha.month == hoy.month &&
            r.fecha.day == hoy.day)
        .fold(0.0, (suma, r) => suma + r.comision);

    return gastosHoy + prestamosHoy + ruleteoHoy;
  }

  int get diasRestantes {
    if (fechaUltimoSueldo == null) return frecuenciaSueldo;

    final proximoSueldo = fechaUltimoSueldo!.add(
      Duration(days: frecuenciaSueldo),
    );

    final diferencia = proximoSueldo.difference(DateTime.now()).inDays + 1;
    return diferencia <= 0 ? 1 : diferencia;
  }

  double get puedesGastarHoy => disponibleReal / diasRestantes;

  List<Map<String, dynamic>> movimientosResumen() {
    final movimientos = [
      ...gastos.map((g) => {
            'id': g.id,
            'tipo': 'gasto',
            'monto': g.monto,
            'titulo': g.bancoTarjeta == null
                ? '${g.categoria} - ${g.medioPago}'
                : '${g.categoria} - ${g.medioPago} ${g.bancoTarjeta}',
            'fecha': g.fecha,
          }),
      ...ingresos.map((i) => {
            'id': i.id,
            'tipo': 'ingreso',
            'monto': i.monto,
            'titulo': i.tipo,
            'fecha': i.fecha,
          }),
      ...pagosTarjeta.map((p) => {
            'id': p.id,
            'tipo': 'pago_tc',
            'monto': p.monto,
            'titulo': 'Pago TC ${p.banco}',
            'fecha': p.fecha,
          }),
      ...ruleteos.map((r) => {
            'id': r.id,
            'tipo': 'ruleteo',
            'monto': r.comision,
            'titulo':
                'Ruleteo ${r.bancoOrigen} → ${r.bancoDestino} | Comisión',
            'fecha': r.fecha,
          }),
      ...pagosPrestamo.map((p) => {
            'id': p.id,
            'tipo': 'pago_prestamo',
            'monto': p.monto,
            'titulo': p.tipo == 'CAPITAL'
                ? 'Pago a capital'
                : 'Pago cuota préstamo',
            'fecha': p.fecha,
          }),
    ];

    movimientos.sort((a, b) {
      final fechaA = a['fecha'] as DateTime;
      final fechaB = b['fecha'] as DateTime;
      return fechaB.compareTo(fechaA);
    });

    return movimientos;
  }

  Future<String?> preguntarNuevoSueldo(double saldoAnterior) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo sueldo detectado'),
          content: Text(
            'Saldo anterior: S/ ${saldoAnterior.toStringAsFixed(2)}\n\n¿Qué deseas hacer?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'continuar'),
              child: const Text('Continuar con saldo'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'resetear'),
              child: const Text('Resetear y ahorrar saldo'),
            ),
          ],
        );
      },
    );
  }

  Future<void> procesarIngreso(Ingreso nuevoIngreso) async {
    if (nuevoIngreso.tipo == 'Sueldo') {
      final saldoAnterior = disponibleReal;
      String decision = 'resetear';

      if (ingresos.isNotEmpty || gastos.isNotEmpty) {
        final respuesta = await preguntarNuevoSueldo(saldoAnterior);
        if (respuesta == null) return;
        decision = respuesta;
      }

      setState(() {
        if (decision == 'continuar') {
          ingresos.clear();
          gastos.clear();
          pagosTarjeta.clear();
          ruleteos.clear();
          pagosPrestamo.clear();

          ingresos.add(
            Ingreso(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              monto: saldoAnterior + nuevoIngreso.monto,
              tipo: 'Sueldo',
              fecha: nuevoIngreso.fecha,
            ),
          );
        } else {
          if (saldoAnterior > 0) {
            ahorroAcumulado += saldoAnterior;
          }

          ingresos.clear();
          gastos.clear();
          pagosTarjeta.clear();
          ruleteos.clear();
          pagosPrestamo.clear();
          ingresos.add(nuevoIngreso);
        }

        fechaUltimoSueldo = nuevoIngreso.fecha;
      });
    } else {
      setState(() {
        ingresos.add(nuevoIngreso);
      });
    }

    await guardarDatos();
  }

  Future<void> confirmarEliminarMovimiento({
    required String tipo,
    required String id,
    required String titulo,
    required double monto,
  }) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar movimiento'),
          content: Text(
            '¿Deseas eliminar?\n\n$titulo\nS/ ${monto.toStringAsFixed(2)}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      setState(() {
        if (tipo == 'gasto') {
          gastos.removeWhere((g) => g.id == id);
        } else if (tipo == 'ingreso') {
          ingresos.removeWhere((i) => i.id == id);
        } else if (tipo == 'pago_tc') {
          pagosTarjeta.removeWhere((p) => p.id == id);
        } else if (tipo == 'ruleteo') {
          ruleteos.removeWhere((r) => r.id == id);
        } else if (tipo == 'pago_prestamo') {
          pagosPrestamo.removeWhere((p) => p.id == id);
        }
      });

      await guardarDatos();
    }
  }

  Future<void> pedirNombreUsuario({bool obligatorio = false}) async {
    final controller = TextEditingController(text: nombreUsuario);

    final nombre = await showDialog<String>(
      context: context,
      barrierDismissible: !obligatorio,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Cómo te llamas?'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Tu nombre',
              hintText: 'Ejemplo: Alex',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            if (!obligatorio)
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ElevatedButton(
              onPressed: () {
                final valor = controller.text.trim();
                if (valor.isEmpty) return;
                Navigator.pop(context, valor);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (nombre != null && nombre.trim().isNotEmpty) {
      setState(() {
        nombreUsuario = nombre.trim();
      });
      await guardarDatos();
    }
  }

  Future<void> editarAhorroAcumulado() async {
    final controller = TextEditingController(
      text: ahorroAcumulado.toStringAsFixed(2),
    );

    final nuevoAhorro = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar ahorro acumulado'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nuevo monto',
              prefixText: 'S/ ',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final valor = double.tryParse(
                  controller.text.replaceAll(',', '.'),
                );

                if (valor == null || valor < 0) return;

                Navigator.pop(context, valor);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (nuevoAhorro != null) {
      setState(() {
        ahorroAcumulado = nuevoAhorro;
      });

      await guardarDatos();
    }
  }

  Widget resumenChip({
    required IconData icon,
    required String titulo,
    required String valor,
    required Color color,
    VoidCallback? onTap,
    String? subtitulo,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 8),
              Text(
                titulo,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0B1F17),
                ),
              ),
              if (subtitulo != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitulo,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget accionPrincipal({
    required String texto,
    required IconData icono,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Expanded(
      child: SizedBox(
        height: 58,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icono),
          label: Text(
            texto,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  void abrirTarjetas() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TarjetasScreen(
          tarjetas: tarjetas,
          gastos: gastos,
          pagosTarjeta: pagosTarjeta,
          ruleteos: ruleteos,
          onRegistrarRuleteo: (ruleteo) async {
            setState(() {
              ruleteos.add(ruleteo);
            });
            await guardarDatos();
          },
          onGuardarTarjetas: (nuevasTarjetas) async {
            setState(() {
              tarjetas.clear();
              tarjetas.addAll(nuevasTarjetas);
            });
            await guardarDatos();
          },
          onRegistrarPago: (pago) async {
            setState(() {
              pagosTarjeta.add(pago);
            });
            await guardarDatos();
          },
        ),
      ),
    );
  }

  void abrirPrestamos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrestamosScreen(
          prestamos: prestamos,
          pagosPrestamo: pagosPrestamo,
          onGuardarPrestamos: (nuevosPrestamos) async {
            setState(() {
              prestamos.clear();
              prestamos.addAll(nuevosPrestamos);
            });
            await guardarDatos();
          },
          onRegistrarPago: (pago) async {
            setState(() {
              pagosPrestamo.add(pago);
            });
            await guardarDatos();
          },
          onEliminarPago: (id) async {
            setState(() {
              pagosPrestamo.removeWhere((p) => p.id == id);
            });
            await guardarDatos();
          },
        ),
      ),
    );
  }

  void abrirHistorial() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistorialScreen(
          gastos: gastos,
          ingresos: ingresos,
          pagosTarjeta: pagosTarjeta,
          ruleteos: ruleteos,
          pagosPrestamo: pagosPrestamo,
          onEliminar: (tipo, id) async {
            setState(() {
              if (tipo == 'gasto') {
                gastos.removeWhere((g) => g.id == id);
              } else if (tipo == 'ingreso') {
                ingresos.removeWhere((i) => i.id == id);
              } else if (tipo == 'pago_tc') {
                pagosTarjeta.removeWhere((p) => p.id == id);
              } else if (tipo == 'ruleteo') {
                ruleteos.removeWhere((r) => r.id == id);
              } else if (tipo == 'pago_prestamo') {
                pagosPrestamo.removeWhere((p) => p.id == id);
              }
            });
            await guardarDatos();
          },
        ),
      ),
    );
  }


  List<Map<String, dynamic>> obligacionesProximas() {
    final alertas = <Map<String, dynamic>>[];

    for (final tarjeta in tarjetas) {
      final facturacion = proximaFechaMensual(tarjeta.diaFacturacion);
      final pago = proximaFechaMensual(tarjeta.diaPago);
      final diasFacturacion = diasHasta(facturacion);
      final diasPago = diasHasta(pago);

      if (diasFacturacion == 0) {
        alertas.add({
          'tipo': 'FACTURACION_TC',
          'titulo': 'Facturación ${tarjeta.banco}',
          'detalle': 'Hoy cierra la facturación de tu tarjeta.',
          'fecha': facturacion,
          'dias': diasFacturacion,
          'color': colorBanco(tarjeta.banco),
        });
      }

      if (diasPago >= 0 && diasPago <= 5) {
        alertas.add({
          'tipo': 'PAGO_TC',
          'titulo': 'Pago TC ${tarjeta.banco}',
          'detalle': diasPago == 0
              ? 'Hoy vence el pago de tu tarjeta.'
              : 'Faltan $diasPago días para pagar tu tarjeta.',
          'fecha': pago,
          'dias': diasPago,
          'color': colorBanco(tarjeta.banco),
        });
      }
    }

    for (final prestamo in prestamos) {
      final pagos = pagosPrestamo
          .where((p) => p.prestamoId == prestamo.id && p.tipo == 'CUOTA')
          .length;
      final proximaCuota = fechaPagoDesdeInicio(
        prestamo.fechaInicio,
        prestamo.diaPago,
        pagos + 1,
      );
      final dias = diasHasta(proximaCuota);
      if (dias >= 0 && dias <= 5) {
        alertas.add({
          'tipo': 'PAGO_PRESTAMO',
          'titulo': 'Préstamo ${prestamo.entidad}',
          'detalle': dias == 0
              ? 'Hoy vence tu próxima cuota.'
              : 'Faltan $dias días para tu próxima cuota.',
          'fecha': proximaCuota,
          'dias': dias,
          'color': colorEntidad(prestamo.entidad),
        });
      }
    }

    alertas.sort((a, b) => (a['fecha'] as DateTime).compareTo(b['fecha'] as DateTime));
    return alertas;
  }

  void abrirNotificaciones() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificacionesScreen(
          obligaciones: obligacionesProximas(),
        ),
      ),
    );
  }

  void abrirMenuMas() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          decoration: const BoxDecoration(
            color: Color(0xFFF6F5FF),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 18),

              const Text(
                'Más opciones',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 16),

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEDEBFF),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Color(0xFF5A55F2),
                  ),
                ),
                title: const Text(
                  'Presupuestos',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: const Text('Configura límite mensual por categoría'),
                onTap: () {
                  Navigator.pop(context);
                  abrirPresupuestos();
                },
              ),

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEDEBFF),
                  child: Icon(
                    Icons.flag_outlined,
                    color: Color(0xFF5A55F2),
                  ),
                ),
                title: const Text(
                  'Metas de ahorro',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: const Text('Organiza tu ahorro acumulado'),
                onTap: () {
                  Navigator.pop(context);
                  abrirMetasAhorro();
                },
              ),

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEDEBFF),
                  child: Icon(
                    Icons.speed,
                    color: Color(0xFF5A55F2),
                  ),
                ),
                title: const Text(
                  'Score financiero',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: const Text('Revisa tu salud financiera'),
                onTap: () {
                  Navigator.pop(context);
                  abrirScoreFinanciero();
                },
              ),

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEDEBFF),
                  child: Icon(
                    Icons.trending_up,
                    color: Color(0xFF5A55F2),
                  ),
                ),
                title: const Text(
                  'Proyección',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: const Text('Mira cómo podría avanzar tu dinero'),
                onTap: () {
                  Navigator.pop(context);
                  abrirProyeccion();
                },
              ),

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFEEF2),
                  child: Icon(
                    Icons.notifications_active_outlined,
                    color: Color(0xFFFF5C7A),
                  ),
                ),
                title: const Text(
                  'Notificaciones',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: const Text('Pagos, cuotas y vencimientos próximos'),
                onTap: () {
                  Navigator.pop(context);
                  abrirNotificaciones();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, double> presupuestoMap() {
    return {
      for (final p in presupuestosCategoria) p.categoria: p.montoMensual,
    };
  }

  double gastoCategoriaMes(String categoria) {
    final hoy = DateTime.now();
    return gastos
        .where((g) =>
            g.categoria == categoria &&
            g.fecha.year == hoy.year &&
            g.fecha.month == hoy.month)
        .fold(0.0, (suma, g) => suma + g.monto);
  }

  double presupuestoCategoria(String categoria) {
    final match = presupuestosCategoria.where((p) => p.categoria == categoria);
    if (match.isEmpty) return 0;
    return match.first.montoMensual;
  }

  Map<String, double> get presupuestoRestantePorCategoria {
    final resultado = <String, double>{};

    for (final categoria in categoriasBase) {
      final presupuesto = presupuestoCategoria(categoria);
      final gastado = gastoCategoriaMes(categoria);
      resultado[categoria] = presupuesto - gastado;
    }

    return resultado;
  }

  void abrirPresupuestos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PresupuestosScreen(
          presupuestos: presupuestosCategoria,
          gastos: gastos,
          onGuardar: (nuevos) async {
            setState(() {
              presupuestosCategoria.clear();
              presupuestosCategoria.addAll(nuevos);
            });
            await guardarDatos();
          },
        ),
      ),
    );
  }

  void abrirDashboardCategorias() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardCategoriasScreen(
          gastos: gastos,
          presupuestos: presupuestosCategoria,
        ),
      ),
    );
  }

  Future<void> compartirApp() async {
    const mensaje = '''
💰 Estoy usando Mi Disponible

Controla:
✅ Gastos
✅ Presupuestos
✅ Tarjetas de crédito
✅ Préstamos
✅ Metas de ahorro

📲 Descargar Mi Disponible:
https://bit.ly/MiDisponibleAppNS
''';

    await Clipboard.setData(const ClipboardData(text: mensaje));
    if (!mounted) return;

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Compartir app'),
        content: const Text(
          'Copié el mensaje de invitación. Pégalo en WhatsApp, Telegram o donde quieras compartirlo.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Listo'),
          ),
        ],
      ),
    );
  }

  void abrirMetasAhorro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MetasAhorroScreen(
          metas: metasAhorro,
          ahorroAcumulado: ahorroAcumulado,
          onGuardarMetas: (nuevasMetas) async {
            setState(() {
              metasAhorro.clear();
              metasAhorro.addAll(nuevasMetas);
            });
            await guardarDatos();
          },
        ),
      ),
    );
  }

  void abrirScoreFinanciero() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScoreFinancieroScreen(
          score: scoreFinanciero(),
          etiqueta: etiquetaScore(),
          disponibleReal: disponibleReal,
          ahorroAcumulado: ahorroAcumulado,
          deudaTotal: totalDeudaGeneral,
          tarjetasPendientes: totalTarjetasPendientes,
          prestamosPendientes: totalCapitalPrestamos,
          gastoPromedioDiario: gastoPromedioUltimos30Dias(),
          obligacionesProximas: obligacionesProximas().length,
        ),
      ),
    );
  }

  void abrirProyeccion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProyeccionFinancieraScreen(
          disponibleReal: disponibleReal,
          ahorroAcumulado: ahorroAcumulado,
          puedesGastarHoy: puedesGastarHoy,
          gastoPromedioDiario: gastoPromedioUltimos30Dias(),
          deudaTotal: totalDeudaGeneral,
        ),
      ),
    );
  }

  Widget bloqueObligacionesProximas() {
    final obligaciones = obligacionesProximas().take(3).toList();
    if (obligaciones.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Obligaciones próximas',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: abrirNotificaciones,
              icon: const Icon(Icons.notifications_active_outlined, size: 18),
              label: const Text('Ver'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...obligaciones.map((o) {
          final color = o['color'] as Color;
          final fecha = o['fecha'] as DateTime;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.14),
                child: Icon(Icons.notifications_active, color: color, size: 20),
              ),
              title: Text(
                o['titulo'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${o['detalle']} · ${formatoFecha(fecha)}'),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final ultimosMovimientos = movimientosResumen().take(8).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
        title: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => pedirNombreUsuario(),
              child: Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.32)),
                ),
                child: Center(
                  child: Text(
                    nombreUsuario.isEmpty
                        ? 'MD'
                        : nombreUsuario.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hola, ${nombreUsuario.isEmpty ? 'usuario' : nombreUsuario} 👋',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Controla tu dinero diario',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              tooltip: 'Dashboard',
              onPressed: abrirDashboardCategorias,
              icon: const Icon(Icons.bar_chart_rounded),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              tooltip: 'Compartir app',
              onPressed: compartirApp,
              icon: const Icon(Icons.ios_share_rounded),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFC2C8FF),
              Color(0xFF7C3AED),
              Color(0xFFF6F5FF),
            ],
            stops: [0.0, 0.38, 0.38],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Disponible real · PEN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'S/ ${disponibleReal.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.24),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Text(
                    'Gasto diario: S/ ${puedesGastarHoy.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F5FF),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 28),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _RevolutAction(
                              icon: Icons.remove,
                              label: 'Gasto',
                              onTap: () async {
                                final nuevoGasto = await Navigator.push<Gasto>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RegistrarGastoScreen(
                                      tarjetas: tarjetas,
                                      gastos: gastos,
                                      presupuestos: presupuestoRestantePorCategoria,
                                      puedesGastarHoy: puedesGastarHoy,
                                    ),
                                  ),
                                );

                                if (nuevoGasto != null) {
                                  setState(() {
                                    gastos.add(nuevoGasto);
                                  });
                                  await guardarDatos();
                                }
                              },
                            ),
                            _RevolutAction(
                              icon: Icons.add,
                              label: 'Ingreso',
                              onTap: () async {
                                final nuevoIngreso = await Navigator.push<Ingreso>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegistrarIngresoScreen(),
                                  ),
                                );

                                if (nuevoIngreso != null) {
                                  await procesarIngreso(nuevoIngreso);
                                }
                              },
                            ),
                            _RevolutAction(
                              icon: Icons.pie_chart_rounded,
                              label: 'Dashboard',
                              onTap: abrirDashboardCategorias,
                            ),
                            _RevolutAction(
                              icon: Icons.more_horiz,
                              label: 'Más',
                              onTap: abrirMenuMas,
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  _MiniMetric(
                                    icon: Icons.shopping_bag_outlined,
                                    title: 'Hoy',
                                    value: 'S/ ${gastadoHoy.toStringAsFixed(2)}',
                                    color: const Color(0xFFFF5C7A),
                                  ),
                                  const SizedBox(width: 10),
                                  _MiniMetric(
                                    icon: Icons.savings_outlined,
                                    title: 'Ahorro',
                                    value: 'S/ ${ahorroAcumulado.toStringAsFixed(2)}',
                                    color: const Color(0xFF5A55F2),
                                    onTap: editarAhorroAcumulado,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  _MiniMetric(
                                    icon: Icons.credit_card,
                                    title: 'TC',
                                    value: 'S/ ${totalTarjetasPendientes.toStringAsFixed(2)}',
                                    color: const Color(0xFF7C5CFF),
                                    onTap: abrirTarjetas,
                                  ),
                                  const SizedBox(width: 10),
                                  _MiniMetric(
                                    icon: Icons.account_balance,
                                    title: 'Préstamos',
                                    value: 'S/ ${totalCapitalPrestamos.toStringAsFixed(2)}',
                                    color: const Color(0xFF646B7A),
                                    onTap: abrirPrestamos,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (obligacionesProximas().isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Obligaciones próximas',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: abrirNotificaciones,
                                      child: const Text('Ver todas'),
                                    ),
                                  ],
                                ),
                                ...obligacionesProximas().take(2).map((o) {
                                  final color = o['color'] as Color;
                                  final fecha = o['fecha'] as DateTime;
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: color.withOpacity(0.14),
                                      child: Icon(Icons.notifications_active, color: color),
                                    ),
                                    title: Text(
                                      o['titulo'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.w800),
                                    ),
                                    subtitle: Text('${o['detalle']} · ${formatoFecha(fecha)}'),
                                  );
                                }),
                              ],
                            ),
                          ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: _PillButton(
                            icon: Icons.history,
                            label: 'Ver historial completo',
                            onTap: abrirHistorial,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Últimos movimientos',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (ultimosMovimientos.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                  child: Center(
                                    child: Text(
                                      'No hay transacciones todavía',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                )
                              else
                                ...ultimosMovimientos.map((mov) {
                                  final id = mov['id'] as String;
                                  final tipo = mov['tipo'] as String;
                                  final esIngreso = tipo == 'ingreso';
                                  final esPagoTc = tipo == 'pago_tc';
                                  final esRuleteo = tipo == 'ruleteo';
                                  final esPagoPrestamo = tipo == 'pago_prestamo';
                                  final monto = mov['monto'] as double;
                                  final titulo = mov['titulo'] as String;
                                  final fecha = mov['fecha'] as DateTime;
                                  final positivo = esIngreso || esPagoTc;

                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    onLongPress: () {
                                      confirmarEliminarMovimiento(
                                        tipo: tipo,
                                        id: id,
                                        titulo: titulo,
                                        monto: monto,
                                      );
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: positivo
                                          ? const Color(0xFFEDEBFF)
                                          : const Color(0xFFFFEEF2),
                                      child: Icon(
                                        positivo
                                            ? Icons.arrow_downward
                                            : esPagoPrestamo
                                                ? Icons.account_balance
                                                : Icons.arrow_upward,
                                        color: positivo
                                            ? const Color(0xFF5A55F2)
                                            : const Color(0xFFFF5C7A),
                                      ),
                                    ),
                                    title: Text(
                                      titulo,
                                      style: const TextStyle(fontWeight: FontWeight.w800),
                                    ),
                                    subtitle: Text(formatoFecha(fecha)),
                                    trailing: Text(
                                      esPagoTc
                                          ? 'Pago S/ ${monto.toStringAsFixed(2)}'
                                          : esRuleteo
                                              ? '- S/ ${monto.toStringAsFixed(2)}'
                                              : '${esIngreso ? '+' : '-'} S/ ${monto.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: positivo
                                            ? const Color(0xFF5A55F2)
                                            : const Color(0xFFFF5C7A),
                                      ),
                                    ),
                                  );
                                }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// ===================== METAS, SCORE Y PROYECCION =====================

class MetasAhorroScreen extends StatefulWidget {
  final List<MetaAhorro> metas;
  final double ahorroAcumulado;
  final Future<void> Function(List<MetaAhorro> metas) onGuardarMetas;

  const MetasAhorroScreen({
    super.key,
    required this.metas,
    required this.ahorroAcumulado,
    required this.onGuardarMetas,
  });

  @override
  State<MetasAhorroScreen> createState() => _MetasAhorroScreenState();
}

class _MetasAhorroScreenState extends State<MetasAhorroScreen> {
  late List<MetaAhorro> metasLocales;

  @override
  void initState() {
    super.initState();
    metasLocales = List.from(widget.metas);
  }

  double get totalAsignado => metasLocales.fold(0.0, (suma, m) => suma + m.montoActual);
  double get ahorroLibre => (widget.ahorroAcumulado - totalAsignado) < 0 ? 0 : widget.ahorroAcumulado - totalAsignado;

  Future<void> agregarMeta() async {
    final nueva = await Navigator.push<MetaAhorro>(
      context,
      MaterialPageRoute(
        builder: (_) => const RegistrarMetaAhorroScreen(),
      ),
    );

    if (nueva != null) {
      setState(() => metasLocales.add(nueva));
      await widget.onGuardarMetas(metasLocales);
    }
  }

  Future<void> editarMeta(MetaAhorro meta) async {
    final editada = await Navigator.push<MetaAhorro>(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrarMetaAhorroScreen(meta: meta),
      ),
    );

    if (editada != null) {
      setState(() {
        final index = metasLocales.indexWhere((m) => m.id == meta.id);
        if (index != -1) metasLocales[index] = editada;
      });
      await widget.onGuardarMetas(metasLocales);
    }
  }

  Future<void> eliminarMeta(MetaAhorro meta) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar meta'),
        content: Text('¿Deseas eliminar ${meta.nombre}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmar == true) {
      setState(() => metasLocales.removeWhere((m) => m.id == meta.id));
      await widget.onGuardarMetas(metasLocales);
    }
  }

  Future<void> aportarMeta(MetaAhorro meta) async {
    final controller = TextEditingController();
    final monto = await showDialog<double>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Asignar ahorro a ${meta.nombre}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Monto a asignar',
            helperText: 'Ahorro libre: S/ ${ahorroLibre.toStringAsFixed(2)}',
            prefixText: 'S/ ',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final valor = double.tryParse(controller.text.replaceAll(',', '.'));
              if (valor == null || valor <= 0) return;
              Navigator.pop(context, valor);
            },
            child: const Text('Asignar'),
          ),
        ],
      ),
    );

    if (monto == null) return;
    final nuevoMonto = redondear((meta.montoActual + monto).clamp(0, meta.montoMeta));
    final editada = MetaAhorro(
      id: meta.id,
      nombre: meta.nombre,
      montoMeta: meta.montoMeta,
      montoActual: nuevoMonto,
      fechaCreacion: meta.fechaCreacion,
    );

    setState(() {
      final index = metasLocales.indexWhere((m) => m.id == meta.id);
      if (index != -1) metasLocales[index] = editada;
    });
    await widget.onGuardarMetas(metasLocales);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metas de ahorro')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: agregarMeta,
        icon: const Icon(Icons.add),
        label: const Text('Nueva meta'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ahorro distribuido', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 6),
                Text('S/ ${totalAsignado.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text('Libre: S/ ${ahorroLibre.toStringAsFixed(2)} de S/ ${widget.ahorroAcumulado.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (metasLocales.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text('Aún no tienes metas. Crea una meta para organizar tu ahorro.'),
              ),
            )
          else
            ...metasLocales.map((m) {
              final progreso = m.montoMeta <= 0 ? 0.0 : (m.montoActual / m.montoMeta).clamp(0.0, 1.0);
              final faltante = (m.montoMeta - m.montoActual).clamp(0, m.montoMeta);
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(child: Icon(Icons.flag_outlined)),
                        title: Text(m.nombre, style: const TextStyle(fontWeight: FontWeight.w900)),
                        subtitle: Text('Faltan: S/ ${faltante.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => editarMeta(m)),
                            IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => eliminarMeta(m)),
                          ],
                        ),
                      ),
                      LinearProgressIndicator(value: progreso, minHeight: 8, borderRadius: BorderRadius.circular(99)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: Text('S/ ${m.montoActual.toStringAsFixed(2)} / S/ ${m.montoMeta.toStringAsFixed(2)}')),
                          Text('${(progreso * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: ahorroLibre <= 0 || progreso >= 1 ? null : () => aportarMeta(m),
                          icon: const Icon(Icons.savings_outlined),
                          label: const Text('Asignar ahorro'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class RegistrarMetaAhorroScreen extends StatefulWidget {
  final MetaAhorro? meta;

  const RegistrarMetaAhorroScreen({super.key, this.meta});

  @override
  State<RegistrarMetaAhorroScreen> createState() => _RegistrarMetaAhorroScreenState();
}

class _RegistrarMetaAhorroScreenState extends State<RegistrarMetaAhorroScreen> {
  final nombreController = TextEditingController();
  final metaController = TextEditingController();
  final actualController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final meta = widget.meta;
    if (meta != null) {
      nombreController.text = meta.nombre;
      metaController.text = meta.montoMeta.toStringAsFixed(2);
      actualController.text = meta.montoActual.toStringAsFixed(2);
    }
  }

  void guardar() {
    final nombre = nombreController.text.trim();
    final montoMeta = double.tryParse(metaController.text.replaceAll(',', '.'));
    final montoActual = double.tryParse(actualController.text.replaceAll(',', '.')) ?? 0;

    if (nombre.isEmpty || montoMeta == null || montoMeta <= 0 || montoActual < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa nombre y meta correctamente.')),
      );
      return;
    }

    Navigator.pop(
      context,
      MetaAhorro(
        id: widget.meta?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        nombre: nombre,
        montoMeta: montoMeta,
        montoActual: montoActual > montoMeta ? montoMeta : montoActual,
        fechaCreacion: widget.meta?.fechaCreacion ?? DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.meta == null ? 'Nueva meta' : 'Editar meta')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(controller: nombreController, decoration: const InputDecoration(labelText: 'Nombre de la meta', hintText: 'Ejemplo: Fondo de emergencia', border: OutlineInputBorder())),
          const SizedBox(height: 15),
          TextField(controller: metaController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Monto objetivo', prefixText: 'S/ ', border: OutlineInputBorder())),
          const SizedBox(height: 15),
          TextField(controller: actualController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Monto actual', prefixText: 'S/ ', border: OutlineInputBorder())),
          const SizedBox(height: 25),
          SizedBox(height: 55, child: ElevatedButton.icon(onPressed: guardar, icon: const Icon(Icons.save), label: const Text('Guardar meta'))),
        ],
      ),
    );
  }
}

class ScoreFinancieroScreen extends StatelessWidget {
  final int score;
  final String etiqueta;
  final double disponibleReal;
  final double ahorroAcumulado;
  final double deudaTotal;
  final double tarjetasPendientes;
  final double prestamosPendientes;
  final double gastoPromedioDiario;
  final int obligacionesProximas;

  const ScoreFinancieroScreen({
    super.key,
    required this.score,
    required this.etiqueta,
    required this.disponibleReal,
    required this.ahorroAcumulado,
    required this.deudaTotal,
    required this.tarjetasPendientes,
    required this.prestamosPendientes,
    required this.gastoPromedioDiario,
    required this.obligacionesProximas,
  });

  Color get color {
    if (score >= 85) return const Color(0xFF0B5D3B);
    if (score >= 70) return const Color(0xFF1565C0);
    if (score >= 50) return const Color(0xFFF57C00);
    return const Color(0xFFD64545);
  }

  Widget indicador(String titulo, String valor, IconData icono, Color c) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: c.withOpacity(0.14), child: Icon(icono, color: c)),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(valor, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Score financiero')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(28)),
            child: Column(
              children: [
                const Text('Score personal', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                Text('$score/100', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900)),
                Text(etiqueta, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          indicador('Disponible real', 'S/ ${disponibleReal.toStringAsFixed(2)}', Icons.account_balance_wallet_outlined, const Color(0xFF0B5D3B)),
          indicador('Ahorro acumulado', 'S/ ${ahorroAcumulado.toStringAsFixed(2)}', Icons.savings_outlined, const Color(0xFF1565C0)),
          indicador('Deuda total', 'S/ ${deudaTotal.toStringAsFixed(2)}', Icons.warning_amber, const Color(0xFFD64545)),
          indicador('Tarjetas pendientes', 'S/ ${tarjetasPendientes.toStringAsFixed(2)}', Icons.credit_card, const Color(0xFF7B1FA2)),
          indicador('Préstamos pendientes', 'S/ ${prestamosPendientes.toStringAsFixed(2)}', Icons.account_balance, const Color(0xFF795548)),
          indicador('Gasto promedio diario', 'S/ ${gastoPromedioDiario.toStringAsFixed(2)}', Icons.show_chart, const Color(0xFFF57C00)),
          indicador('Obligaciones próximas', '$obligacionesProximas', Icons.notifications_active_outlined, const Color(0xFF455A64)),
        ],
      ),
    );
  }
}

class ProyeccionFinancieraScreen extends StatelessWidget {
  final double disponibleReal;
  final double ahorroAcumulado;
  final double puedesGastarHoy;
  final double gastoPromedioDiario;
  final double deudaTotal;

  const ProyeccionFinancieraScreen({
    super.key,
    required this.disponibleReal,
    required this.ahorroAcumulado,
    required this.puedesGastarHoy,
    required this.gastoPromedioDiario,
    required this.deudaTotal,
  });

  double ahorroProyectado(int meses) {
    final excedenteDiario = puedesGastarHoy - gastoPromedioDiario;
    final proyeccion = ahorroAcumulado + (excedenteDiario * 30 * meses);
    return proyeccion < 0 ? 0 : proyeccion;
  }

  double patrimonioProyectado(int meses) {
    final deudaReducida = (deudaTotal - (meses * 0)).clamp(0, deudaTotal);
    return ahorroProyectado(meses) + disponibleReal - deudaReducida;
  }

  Widget filaProyeccion(int meses) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${meses}M')),
        title: Text('En $meses meses', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Ahorro proyectado: S/ ${ahorroProyectado(meses).toStringAsFixed(2)}'),
        trailing: Text('Patrimonio\nS/ ${patrimonioProyectado(meses).toStringAsFixed(0)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final excedente = puedesGastarHoy - gastoPromedioDiario;
    return Scaffold(
      appBar: AppBar(title: const Text('Proyección')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: excedente >= 0 ? const Color(0xFF0B5D3B) : const Color(0xFFD64545),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ritmo actual', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text(
                  excedente >= 0 ? 'Vas generando margen' : 'Estás gastando por encima del ritmo',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text('Margen diario estimado: S/ ${excedente.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          filaProyeccion(3),
          filaProyeccion(6),
          filaProyeccion(12),
          const SizedBox(height: 10),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('La proyección usa tu disponible diario y tu gasto promedio de los últimos 30 días. Es una estimación referencial para tomar decisiones.'),
            ),
          ),
        ],
      ),
    );
  }
}



class _RevolutAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RevolutAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF5A55F2), size: 28),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 78,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const _MiniMetric({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.14),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF5A55F2), size: 22),
            const SizedBox(height: 5),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class NotificacionesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> obligaciones;

  const NotificacionesScreen({
    super.key,
    required this.obligaciones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: obligaciones.isEmpty
          ? const Center(
              child: Text(
                'No tienes obligaciones próximas.Las alertas aparecen 5 días antes del pago y el día de facturación.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: obligaciones.length,
              itemBuilder: (context, index) {
                final o = obligaciones[index];
                final color = o['color'] as Color;
                final dias = o['dias'] as int;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.14),
                      child: Icon(Icons.notifications_active, color: color),
                    ),
                    title: Text(
                      o['titulo'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    subtitle: Text(o['detalle'] as String),
                    trailing: Text(
                      dias == 0 ? 'Hoy' : '${dias}d',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    isThreeLine: false,
                  ),
                );
              },
          ),
    );
  }
}

// ===================== TARJETAS =====================

class TarjetasScreen extends StatefulWidget {
  final List<TarjetaCredito> tarjetas;
  final List<Gasto> gastos;
  final List<PagoTarjeta> pagosTarjeta;
  final Future<void> Function(List<TarjetaCredito> tarjetas) onGuardarTarjetas;
  final Future<void> Function(PagoTarjeta pago) onRegistrarPago;
  final List<Ruleteo> ruleteos;
  final Future<void> Function(Ruleteo ruleteo) onRegistrarRuleteo;

  const TarjetasScreen({
    super.key,
    required this.tarjetas,
    required this.gastos,
    required this.pagosTarjeta,
    required this.onGuardarTarjetas,
    required this.onRegistrarPago,
    required this.ruleteos,
    required this.onRegistrarRuleteo,
  });

  @override
  State<TarjetasScreen> createState() => _TarjetasScreenState();
}

class _TarjetasScreenState extends State<TarjetasScreen> {
  late List<TarjetaCredito> tarjetasLocales;

  @override
  void initState() {
    super.initState();
    tarjetasLocales = List.from(widget.tarjetas);
  }

  Future<void> editarTarjeta(TarjetaCredito tarjeta) async {
    final editada = await Navigator.push<TarjetaCredito>(
      context,
      MaterialPageRoute(
        builder: (_) => EditarTarjetaScreen(tarjeta: tarjeta),
      ),
    );

    if (editada != null) {
      setState(() {
        final index = tarjetasLocales.indexWhere((t) => t.id == tarjeta.id);
        if (index != -1) {
          tarjetasLocales[index] = editada;
        }
      });

      await widget.onGuardarTarjetas(tarjetasLocales);
    }
  }

  Future<void> registrarRuleteo() async {
    if (tarjetasLocales.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Necesitas al menos 2 tarjetas para hacer ruleteo.',
          ),
        ),
      );
      return;
    }

    final nuevoRuleteo = await Navigator.push<Ruleteo>(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrarRuleteoScreen(
          tarjetas: tarjetasLocales,
        ),
      ),
    );

    if (nuevoRuleteo != null) {
      await widget.onRegistrarRuleteo(nuevoRuleteo);
      setState(() {});
    }
  }

  double consumoBanco(String banco) {
    final compras = widget.gastos
        .where((g) => g.medioPago == 'Tarjeta' && g.bancoTarjeta == banco)
        .fold(0.0, (suma, g) => suma + g.monto);

    final ruleteoOrigen = widget.ruleteos
        .where((r) => r.bancoOrigen == banco)
        .fold(0.0, (suma, r) => suma + r.monto);

    return compras + ruleteoOrigen;
  }

  double pagosBanco(String banco) {
    final pagos = widget.pagosTarjeta
        .where((p) => p.banco == banco)
        .fold(0.0, (suma, p) => suma + p.monto);

    final ruleteoDestino = widget.ruleteos
        .where((r) => r.bancoDestino == banco)
        .fold(0.0, (suma, r) => suma + r.monto);

    return pagos + ruleteoDestino;
  }

  double deudaBanco(String banco) {
    final deuda = consumoBanco(banco) - pagosBanco(banco);
    return deuda < 0 ? 0 : deuda;
  }

  double facturaActual(String banco, int diaFacturacion) {
    final hoy = DateTime.now();

    return widget.gastos
        .where((g) =>
            g.medioPago == 'Tarjeta' &&
            g.bancoTarjeta == banco &&
            g.fecha.day <= diaFacturacion &&
            g.fecha.month == hoy.month &&
            g.fecha.year == hoy.year)
        .fold(0.0, (suma, g) => suma + g.monto);
  }

  double proximaFactura(String banco, int diaFacturacion) {
    final hoy = DateTime.now();

    return widget.gastos
        .where((g) =>
            g.medioPago == 'Tarjeta' &&
            g.bancoTarjeta == banco &&
            g.fecha.day > diaFacturacion &&
            g.fecha.month == hoy.month &&
            g.fecha.year == hoy.year)
        .fold(0.0, (suma, g) => suma + g.monto);
  }

  Future<void> agregarTarjeta() async {
    final nueva = await Navigator.push<TarjetaCredito>(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrarTarjetaScreen(
          bancosYaRegistrados: tarjetasLocales.map((t) => t.banco).toList(),
        ),
      ),
    );

    if (nueva != null) {
      setState(() {
        tarjetasLocales.add(nueva);
      });
      await widget.onGuardarTarjetas(tarjetasLocales);
    }
  }

  Future<void> eliminarTarjeta(TarjetaCredito tarjeta) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar tarjeta'),
          content: Text('¿Deseas eliminar ${tarjeta.banco}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      setState(() {
        tarjetasLocales.removeWhere((t) => t.id == tarjeta.id);
      });
      await widget.onGuardarTarjetas(tarjetasLocales);
    }
  }

  Future<void> registrarPago(TarjetaCredito tarjeta) async {
    final pago = await Navigator.push<PagoTarjeta>(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrarPagoTarjetaScreen(
          banco: tarjeta.banco,
          deudaActual: deudaBanco(tarjeta.banco),
        ),
      ),
    );

    if (pago != null) {
      await widget.onRegistrarPago(pago);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarjetas'),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'ruleteo',
            onPressed: registrarRuleteo,
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Ruleteo'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'agregar_tc',
            onPressed: agregarTarjeta,
            icon: const Icon(Icons.add),
            label: const Text('Agregar TC'),
          ),
        ],
      ),
      body: tarjetasLocales.isEmpty
          ? const Center(
              child: Text(
                'Aún no registraste tarjetas.\nPulsa "Agregar TC".',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tarjetasLocales.length,
              itemBuilder: (context, index) {
                final tarjeta = tarjetasLocales[index];
                final deuda = deudaBanco(tarjeta.banco);
                final disponible = tarjeta.lineaCredito - deuda;
                final porcentaje = tarjeta.lineaCredito <= 0
                    ? 0.0
                    : (deuda / tarjeta.lineaCredito).clamp(0.0, 1.0);
                final color = colorBanco(tarjeta.banco);

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            tarjeta.banco,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: color,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            'Facturación: día ${tarjeta.diaFacturacion} · Pago: día ${tarjeta.diaPago}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => editarTarjeta(tarjeta),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => eliminarTarjeta(tarjeta),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: const Size(140, 140),
                                painter: DonutPainter(
                                  porcentaje: porcentaje,
                                  color: color,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Disponible',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'S/ ${disponible.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Línea: S/ ${tarjeta.lineaCredito.toStringAsFixed(2)}',
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Deuda: S/ ${deuda.toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Pagado: S/ ${pagosBanco(tarjeta.banco).toStringAsFixed(2)}',
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Consumo: S/ ${consumoBanco(tarjeta.banco).toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Factura actual: S/ ${facturaActual(tarjeta.banco, tarjeta.diaFacturacion).toStringAsFixed(2)}',
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Próxima: S/ ${proximaFactura(tarjeta.banco, tarjeta.diaFacturacion).toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: deuda <= 0
                                ? null
                                : () => registrarPago(tarjeta),
                            icon: const Icon(Icons.payments),
                            label: const Text('Registrar pago'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ===================== PRESTAMOS =====================

class PrestamosScreen extends StatefulWidget {
  final List<Prestamo> prestamos;
  final List<PagoPrestamo> pagosPrestamo;
  final Future<void> Function(List<Prestamo> prestamos) onGuardarPrestamos;
  final Future<void> Function(PagoPrestamo pago) onRegistrarPago;
  final Future<void> Function(String pagoId) onEliminarPago;

  const PrestamosScreen({
    super.key,
    required this.prestamos,
    required this.pagosPrestamo,
    required this.onGuardarPrestamos,
    required this.onRegistrarPago,
    required this.onEliminarPago,
  });

  @override
  State<PrestamosScreen> createState() => _PrestamosScreenState();
}

class _PrestamosScreenState extends State<PrestamosScreen> {
  late List<Prestamo> prestamosLocales;

  @override
  void initState() {
    super.initState();
    prestamosLocales = List.from(widget.prestamos);
  }

  double capitalPagado(Prestamo prestamo) {
    return widget.pagosPrestamo
        .where((p) => p.prestamoId == prestamo.id)
        .fold(0.0, (suma, p) => suma + p.capital);
  }

  double saldoPendiente(Prestamo prestamo) {
    final saldo = prestamo.capitalInicial - capitalPagado(prestamo);
    return saldo < 0 ? 0 : saldo;
  }

  int cuotasPagadas(Prestamo prestamo) {
    return widget.pagosPrestamo
        .where((p) => p.prestamoId == prestamo.id && p.tipo == 'CUOTA')
        .length;
  }

  double totalPagado(Prestamo prestamo) {
    return widget.pagosPrestamo
        .where((p) => p.prestamoId == prestamo.id)
        .fold(0.0, (suma, p) => suma + p.monto);
  }

  Future<void> agregarPrestamo() async {
    final nuevo = await Navigator.push<Prestamo>(
      context,
      MaterialPageRoute(
        builder: (_) => const RegistrarPrestamoScreen(),
      ),
    );

    if (nuevo != null) {
      setState(() {
        prestamosLocales.add(nuevo);
      });
      await widget.onGuardarPrestamos(prestamosLocales);
    }
  }

  Future<void> editarPrestamo(Prestamo prestamo) async {
    final editado = await Navigator.push<Prestamo>(
      context,
      MaterialPageRoute(
        builder: (_) => EditarPrestamoScreen(prestamo: prestamo),
      ),
    );

    if (editado != null) {
      setState(() {
        final index = prestamosLocales.indexWhere((p) => p.id == prestamo.id);
        if (index != -1) {
          prestamosLocales[index] = editado;
        }
      });
      await widget.onGuardarPrestamos(prestamosLocales);
    }
  }

  Future<void> eliminarPrestamo(Prestamo prestamo) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar préstamo'),
        content: Text('¿Deseas eliminar ${prestamo.entidad}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() {
        prestamosLocales.removeWhere((p) => p.id == prestamo.id);
      });
      await widget.onGuardarPrestamos(prestamosLocales);
    }
  }

  void abrirDetalle(Prestamo prestamo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetallePrestamoScreen(
          prestamo: prestamo,
          pagos: widget.pagosPrestamo
              .where((p) => p.prestamoId == prestamo.id)
              .toList(),
          onRegistrarPago: (pago) async {
            await widget.onRegistrarPago(pago);
            setState(() {});
          },
          onEliminarPago: (id) async {
            await widget.onEliminarPago(id);
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCapital = prestamosLocales.fold(
      0.0,
      (suma, p) => suma + saldoPendiente(p),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Préstamos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: agregarPrestamo,
        icon: const Icon(Icons.add),
        label: const Text('Agregar préstamo'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF3E2723),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Capital pendiente total',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  'S/ ${totalCapital.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: prestamosLocales.isEmpty
                ? const Center(
                    child: Text(
                      'Aún no registraste préstamos.\nPulsa "Agregar préstamo".',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    itemCount: prestamosLocales.length,
                    itemBuilder: (context, index) {
                      final p = prestamosLocales[index];
                      final saldo = saldoPendiente(p);
                      final pagado = totalPagado(p);
                      final avance = p.capitalInicial <= 0
                          ? 0.0
                          : ((p.capitalInicial - saldo) / p.capitalInicial)
                              .clamp(0.0, 1.0);
                      final color = colorEntidad(p.entidad);

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () => abrirDetalle(p),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor: color.withOpacity(0.15),
                                    child: Icon(
                                      Icons.account_balance,
                                      color: color,
                                    ),
                                  ),
                                  title: Text(
                                    p.entidad,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: color,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Cuota: S/ ${p.cuotaMensual.toStringAsFixed(2)} · 1ra cuota ${formatoFecha(p.fechaInicio)}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => editarPrestamo(p),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () => eliminarPrestamo(p),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: avance,
                                  backgroundColor: Colors.grey.shade200,
                                  color: color,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Saldo: S/ ${saldo.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Pagado: S/ ${pagado.toStringAsFixed(2)}',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'TCEA: ${p.tasaMensual.toStringAsFixed(2)}%',
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Cuotas pagadas: ${cuotasPagadas(p)}',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


class EditarPrestamoScreen extends StatefulWidget {
  final Prestamo prestamo;

  const EditarPrestamoScreen({
    super.key,
    required this.prestamo,
  });

  @override
  State<EditarPrestamoScreen> createState() => _EditarPrestamoScreenState();
}

class _EditarPrestamoScreenState extends State<EditarPrestamoScreen> {
  late TextEditingController capitalController;
  late TextEditingController cuotaController;
  late TextEditingController plazoController;
  late TextEditingController fechaPrimeraCuotaController;
  late TextEditingController tasaController;
  late String entidadSeleccionada;

  @override
  void initState() {
    super.initState();
    entidadSeleccionada = widget.prestamo.entidad;
    capitalController = TextEditingController(text: widget.prestamo.capitalInicial.toStringAsFixed(2));
    cuotaController = TextEditingController(text: widget.prestamo.cuotaMensual.toStringAsFixed(2));
    plazoController = TextEditingController(text: widget.prestamo.plazoMeses.toString());
    fechaPrimeraCuotaController = TextEditingController(text: formatoFecha(widget.prestamo.fechaInicio));
    tasaController = TextEditingController(text: widget.prestamo.tasaMensual.toStringAsFixed(2));
  }

  void guardarCambios() {
    final capital = double.tryParse(capitalController.text.replaceAll(',', '.'));
    final cuota = double.tryParse(cuotaController.text.replaceAll(',', '.'));
    final plazo = int.tryParse(plazoController.text);
    final primeraCuota = parseFechaManual(fechaPrimeraCuotaController.text);
    final tasa = double.tryParse(tasaController.text.replaceAll(',', '.'));

    if (capital == null ||
        capital <= 0 ||
        cuota == null ||
        cuota <= 0 ||
        plazo == null ||
        plazo <= 0 ||
        primeraCuota == null ||
        tasa == null ||
        tasa < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa capital, cuota, plazo, primera cuota y TCEA.'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      Prestamo(
        id: widget.prestamo.id,
        entidad: entidadSeleccionada,
        capitalInicial: capital,
        cuotaMensual: cuota,
        plazoMeses: plazo,
        diaPago: primeraCuota.day,
        tasaMensual: tasa,
        fechaInicio: primeraCuota,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = colorEntidad(entidadSeleccionada);

    return Scaffold(
      appBar: AppBar(title: Text('Editar $entidadSeleccionada')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.35)),
            ),
            child: Row(
              children: [
                Icon(Icons.account_balance, color: color, size: 34),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entidadSeleccionada,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Entidad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: entidadesPrestamo.map((entidad) {
              final c = colorEntidad(entidad);
              return ChoiceChip(
                label: Text(entidad),
                selected: entidadSeleccionada == entidad,
                selectedColor: c.withOpacity(0.25),
                onSelected: (_) => setState(() => entidadSeleccionada = entidad),
              );
            }).toList(),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: capitalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Capital inicial',
              prefixText: 'S/ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: cuotaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cuota mensual',
              prefixText: 'S/ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: plazoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Plazo en meses',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: fechaPrimeraCuotaController,
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(
              labelText: 'Fecha de primera cuota',
              hintText: 'Ejemplo: 15/07/2026',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: tasaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'TCEA anual %',
              hintText: 'Ejemplo: 36',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: guardarCambios,
              icon: const Icon(Icons.save),
              label: const Text('Guardar cambios'),
            ),
          ),
        ],
      ),
    );
  }
}

class RegistrarPrestamoScreen extends StatefulWidget {
  const RegistrarPrestamoScreen({super.key});

  @override
  State<RegistrarPrestamoScreen> createState() => _RegistrarPrestamoScreenState();
}

class _RegistrarPrestamoScreenState extends State<RegistrarPrestamoScreen> {
  final capitalController = TextEditingController();
  final cuotaController = TextEditingController();
  final plazoController = TextEditingController();
  final fechaPrimeraCuotaController = TextEditingController();
  final tasaController = TextEditingController();

  String? entidadSeleccionada;

  void guardarPrestamo() {
    final capital = double.tryParse(capitalController.text.replaceAll(',', '.'));
    final cuota = double.tryParse(cuotaController.text.replaceAll(',', '.'));
    final plazo = int.tryParse(plazoController.text);
    final fechaPrimeraCuota = parseFechaManual(fechaPrimeraCuotaController.text);
    final diaPago = fechaPrimeraCuota?.day;
    final tasa = double.tryParse(tasaController.text.replaceAll(',', '.'));

    if (entidadSeleccionada == null ||
        capital == null ||
        capital <= 0 ||
        cuota == null ||
        cuota <= 0 ||
        plazo == null ||
        plazo <= 0 ||
        fechaPrimeraCuota == null ||
        tasa == null ||
        tasa < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa entidad, capital, cuota, plazo, primera cuota y TCEA.'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      Prestamo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        entidad: entidadSeleccionada!,
        capitalInicial: capital,
        cuotaMensual: cuota,
        plazoMeses: plazo,
        diaPago: diaPago!,
        tasaMensual: tasa,
        fechaInicio: fechaPrimeraCuota,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar préstamo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Entidad',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: entidadesPrestamo.map((entidad) {
              final color = colorEntidad(entidad);
              return ChoiceChip(
                label: Text(entidad),
                selected: entidadSeleccionada == entidad,
                selectedColor: color.withOpacity(0.25),
                onSelected: (_) {
                  setState(() {
                    entidadSeleccionada = entidad;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: capitalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Capital inicial',
              prefixText: 'S/ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: cuotaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cuota mensual',
              prefixText: 'S/ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: plazoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Plazo en meses',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: fechaPrimeraCuotaController,
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(
              labelText: 'Fecha de primera cuota',
              hintText: 'Ejemplo: 15/07/2026',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: tasaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'TCEA anual %',
              hintText: 'Ejemplo: 36',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: guardarPrestamo,
              icon: const Icon(Icons.save),
              label: const Text('Guardar préstamo'),
            ),
          ),
        ],
      ),
    );
  }
}

class DetallePrestamoScreen extends StatefulWidget {
  final Prestamo prestamo;
  final List<PagoPrestamo> pagos;
  final Future<void> Function(PagoPrestamo pago) onRegistrarPago;
  final Future<void> Function(String pagoId) onEliminarPago;

  const DetallePrestamoScreen({
    super.key,
    required this.prestamo,
    required this.pagos,
    required this.onRegistrarPago,
    required this.onEliminarPago,
  });

  @override
  State<DetallePrestamoScreen> createState() => _DetallePrestamoScreenState();
}

class _DetallePrestamoScreenState extends State<DetallePrestamoScreen> {
  late List<PagoPrestamo> pagosLocales;

  @override
  void initState() {
    super.initState();
    pagosLocales = List.from(widget.pagos);
  }

  double get capitalPagado {
    return pagosLocales.fold(0.0, (suma, p) => suma + p.capital);
  }

  double get saldoPendiente {
    final saldo = widget.prestamo.capitalInicial - capitalPagado;
    return saldo < 0 ? 0 : saldo;
  }

  int get cuotasPagadas {
    return pagosLocales.where((p) => p.tipo == 'CUOTA').length;
  }

  double get interesPagado {
    return pagosLocales.fold(0.0, (suma, p) => suma + p.interes);
  }

  List<FilaCronograma> generarCronograma() {
    final filas = <FilaCronograma>[];
    double saldo = widget.prestamo.capitalInicial;

    double temDesdeTcea(double tcea) {
      return pow(1 + (tcea / 100), 1 / 12) - 1;
    }

    final tasa = temDesdeTcea(widget.prestamo.tasaMensual);
    
    for (int i = 1; i <= widget.prestamo.plazoMeses && saldo > 0.01; i++) {
      final interes = redondear(saldo * tasa);
      double capital = widget.prestamo.cuotaMensual - interes;
      if (capital <= 0) capital = 0;
      if (capital > saldo) capital = saldo;
      final cuota = redondear(interes + capital);
      saldo = redondear(saldo - capital);

      final pagado = pagosLocales.any(
        (p) => p.tipo == 'CUOTA' && p.numeroCuota == i,
      );

      filas.add(
        FilaCronograma(
          numero: i,
          fecha: fechaPagoDesdeInicio(
            widget.prestamo.fechaInicio,
            widget.prestamo.diaPago,
            i,
          ),
          cuota: cuota,
          interes: interes,
          capital: redondear(capital),
          saldo: saldo,
          pagado: pagado,
        ),
      );
    }

    return filas;
  }

  List<FilaCronograma> generarCronogramaDesdeSaldo() {
    final filas = <FilaCronograma>[];
    double saldo = saldoPendiente;

    double temDesdeTcea(double tcea) {
      return pow(1 + (tcea / 100), 1 / 12) - 1;
    }

    final tasa = temDesdeTcea(widget.prestamo.tasaMensual);

    int numero = cuotasPagadas + 1;

    final cuotasRestantes = widget.prestamo.plazoMeses - cuotasPagadas;

    while (saldo > 0.01 && filas.length < cuotasRestantes) {
      final interes = redondear(saldo * tasa);
      double capital = widget.prestamo.cuotaMensual - interes;
      if (capital <= 0) {
        capital = 0;
      }
      if (capital > saldo) capital = saldo;
      final cuota = redondear(interes + capital);
      saldo = redondear(saldo - capital);

      filas.add(
        FilaCronograma(
          numero: numero,
          fecha: fechaPagoDesdeInicio(
            widget.prestamo.fechaInicio,
            widget.prestamo.diaPago,
            cuotasPagadas + filas.length + 1,
          ),
          cuota: cuota,
          interes: interes,
          capital: redondear(capital),
          saldo: saldo,
          pagado: false,
        ),
      );

      numero++;
      if (capital <= 0) break;
    }

    return filas;
  }

  Future<void> pagarCuota() async {
    final cronograma = generarCronogramaDesdeSaldo();
    if (cronograma.isEmpty || saldoPendiente <= 0) return;

    final fila = cronograma.first;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pagar cuota'),
        content: Text(
          'Cuota: S/ ${fila.cuota.toStringAsFixed(2)}\n'
          'Interés: S/ ${fila.interes.toStringAsFixed(2)}\n'
          'Capital: S/ ${fila.capital.toStringAsFixed(2)}\n'
          'Saldo nuevo: S/ ${fila.saldo.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Pagar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final pago = PagoPrestamo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        prestamoId: widget.prestamo.id,
        tipo: 'CUOTA',
        monto: fila.cuota,
        interes: fila.interes,
        capital: fila.capital,
        numeroCuota: cuotasPagadas + 1,
        fecha: DateTime.now(),
      );

      await widget.onRegistrarPago(pago);
      setState(() {
        pagosLocales.add(pago);
      });
    }
  }

  Future<void> pagarCapital() async {
    final controller = TextEditingController();

    final monto = await showDialog<double>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pago a capital'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Monto a capital',
            prefixText: 'S/ ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final valor = double.tryParse(controller.text.replaceAll(',', '.'));
              if (valor == null || valor <= 0) return;
              Navigator.pop(context, valor);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (monto == null) return;

    final capital = monto > saldoPendiente ? saldoPendiente : monto;
    final pago = PagoPrestamo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      prestamoId: widget.prestamo.id,
      tipo: 'CAPITAL',
      monto: capital,
      interes: 0,
      capital: capital,
      fecha: DateTime.now(),
    );

    await widget.onRegistrarPago(pago);
    setState(() {
      pagosLocales.add(pago);
    });
  }

  Future<void> eliminarPago(PagoPrestamo pago) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar pago'),
        content: Text(
          '¿Eliminar pago de S/ ${pago.monto.toStringAsFixed(2)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await widget.onEliminarPago(pago.id);
      setState(() {
        pagosLocales.removeWhere((p) => p.id == pago.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = colorEntidad(widget.prestamo.entidad);
    final cronograma = generarCronogramaDesdeSaldo();

    return Scaffold(
      appBar: AppBar(title: Text(widget.prestamo.entidad)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Capital pendiente',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  'S/ ${saldoPendiente.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Cuota: S/ ${widget.prestamo.cuotaMensual.toStringAsFixed(2)} · '
                  'TCEA: ${widget.prestamo.tasaMensual.toStringAsFixed(2)}% anual',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Interés pagado: S/ ${interesPagado.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  'Primera cuota: ${formatoFecha(widget.prestamo.fechaInicio)}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: saldoPendiente <= 0 ? null : pagarCuota,
                  icon: const Icon(Icons.payments),
                  label: const Text('Pagar cuota'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: saldoPendiente <= 0 ? null : pagarCapital,
                  icon: const Icon(Icons.south_west),
                  label: const Text('Pago capital'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Cronograma recalculado',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          const SizedBox(height: 8),
          if (cronograma.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text('Préstamo cancelado.'),
              ),
            )
          else
            ...cronograma.take(24).map((f) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    'Cuota ${f.numero} · ${f.fecha.day}/${f.fecha.month}/${f.fecha.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Interés: S/ ${f.interes.toStringAsFixed(2)} · '
                    'Capital: S/ ${f.capital.toStringAsFixed(2)}',
                  ),
                  trailing: Text(
                    'Saldo\nS/ ${f.saldo.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            }),
          const SizedBox(height: 18),
          const Text(
            'Pagos realizados',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          const SizedBox(height: 8),
          if (pagosLocales.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text('Aún no registraste pagos.'),
              ),
            )
          else
            ...pagosLocales.reversed.map((p) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onLongPress: () => eliminarPago(p),
                  title: Text(
                    p.tipo == 'CAPITAL' ? 'Pago a capital' : 'Pago cuota',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${p.fecha.day}/${p.fecha.month}/${p.fecha.year} · '
                    'Interés: S/ ${p.interes.toStringAsFixed(2)} · '
                    'Capital: S/ ${p.capital.toStringAsFixed(2)}',
                  ),
                  trailing: Text(
                    '- S/ ${p.monto.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFFD64545),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

// ===================== CUSTOM PAINTER =====================

class DonutPainter extends CustomPainter {
  final double porcentaje;
  final Color color;

  DonutPainter({
    required this.porcentaje,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final radio = min(size.width, size.height) / 2;
    const grosor = 14.0;

    final fondo = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = grosor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progreso = Paint()
      ..color = color
      ..strokeWidth = grosor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(centro, radio - grosor, fondo);

    canvas.drawArc(
      Rect.fromCircle(center: centro, radius: radio - grosor),
      -pi / 2,
      2 * pi * porcentaje,
      false,
      progreso,
    );
  }

  @override
  bool shouldRepaint(covariant DonutPainter oldDelegate) {
    return oldDelegate.porcentaje != porcentaje || oldDelegate.color != color;
  }
}

// ===================== PANTALLAS TARJETA =====================

class EditarTarjetaScreen extends StatefulWidget {
  final TarjetaCredito tarjeta;

  const EditarTarjetaScreen({
    super.key,
    required this.tarjeta,
  });

  @override
  State<EditarTarjetaScreen> createState() => _EditarTarjetaScreenState();
}

class _EditarTarjetaScreenState extends State<EditarTarjetaScreen> {
  late TextEditingController lineaController;
  late TextEditingController facturacionController;
  late TextEditingController pagoController;

  @override
  void initState() {
    super.initState();

    lineaController = TextEditingController(
      text: widget.tarjeta.lineaCredito.toStringAsFixed(0),
    );

    facturacionController = TextEditingController(
      text: widget.tarjeta.diaFacturacion.toString(),
    );

    pagoController = TextEditingController(
      text: widget.tarjeta.diaPago.toString(),
    );
  }

  void guardarCambios() {
    final linea = double.tryParse(lineaController.text.replaceAll(',', '.'));
    final facturacion = int.tryParse(facturacionController.text);
    final pago = int.tryParse(pagoController.text);

    if (linea == null ||
        linea <= 0 ||
        facturacion == null ||
        facturacion < 1 ||
        facturacion > 31 ||
        pago == null ||
        pago < 1 ||
        pago > 31) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa línea, facturación y pago correctamente.'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      TarjetaCredito(
        id: widget.tarjeta.id,
        banco: widget.tarjeta.banco,
        lineaCredito: linea,
        diaFacturacion: facturacion,
        diaPago: pago,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = colorBanco(widget.tarjeta.banco);

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${widget.tarjeta.banco}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: color.withOpacity(0.35)),
              ),
              child: Row(
                children: [
                  Icon(Icons.credit_card, color: color, size: 34),
                  const SizedBox(width: 12),
                  Text(
                    widget.tarjeta.banco,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: lineaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Línea de crédito',
                prefixText: 'S/ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: facturacionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Día de facturación',
                hintText: 'Ejemplo: 20',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: pagoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Día de pago',
                hintText: 'Ejemplo: 5',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: guardarCambios,
                icon: const Icon(Icons.save),
                label: const Text('Guardar cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrarTarjetaScreen extends StatefulWidget {
  final List<String> bancosYaRegistrados;

  const RegistrarTarjetaScreen({
    super.key,
    required this.bancosYaRegistrados,
  });

  @override
  State<RegistrarTarjetaScreen> createState() => _RegistrarTarjetaScreenState();
}

class _RegistrarTarjetaScreenState extends State<RegistrarTarjetaScreen> {
  final lineaController = TextEditingController();
  final facturacionController = TextEditingController();
  final pagoController = TextEditingController();

  String? bancoSeleccionado;

  void guardarTarjeta() {
    final linea = double.tryParse(lineaController.text.replaceAll(',', '.'));
    final facturacion = int.tryParse(facturacionController.text);
    final pago = int.tryParse(pagoController.text);

    if (bancoSeleccionado == null ||
        linea == null ||
        linea <= 0 ||
        facturacion == null ||
        facturacion < 1 ||
        facturacion > 31 ||
        pago == null ||
        pago < 1 ||
        pago > 31) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa banco, línea, facturación y pago.'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      TarjetaCredito(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        banco: bancoSeleccionado!,
        lineaCredito: linea,
        diaFacturacion: facturacion,
        diaPago: pago,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bancosDisponibles = bancosDisponiblesTc
        .where(
          (b) => !widget.bancosYaRegistrados.contains(b['nombre'] as String),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar TC')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Banco',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: bancosDisponibles.map((banco) {
                final nombre = banco['nombre'] as String;
                final color = banco['color'] as Color;

                return ChoiceChip(
                  label: Text(nombre),
                  selected: bancoSeleccionado == nombre,
                  selectedColor: color.withOpacity(0.25),
                  onSelected: (_) {
                    setState(() {
                      bancoSeleccionado = nombre;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: lineaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Línea de crédito',
                prefixText: 'S/ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: facturacionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Día de facturación',
                hintText: 'Ejemplo: 20',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: pagoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Día de pago',
                hintText: 'Ejemplo: 5',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: guardarTarjeta,
                child: const Text('Guardar tarjeta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrarPagoTarjetaScreen extends StatefulWidget {
  final String banco;
  final double deudaActual;

  const RegistrarPagoTarjetaScreen({
    super.key,
    required this.banco,
    required this.deudaActual,
  });

  @override
  State<RegistrarPagoTarjetaScreen> createState() =>
      _RegistrarPagoTarjetaScreenState();
}

class _RegistrarPagoTarjetaScreenState
    extends State<RegistrarPagoTarjetaScreen> {
  final montoController = TextEditingController();

  void registrarPago() {
    final monto = double.tryParse(montoController.text.replaceAll(',', '.'));

    if (monto == null || monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un monto válido.')),
      );
      return;
    }

    Navigator.pop(
      context,
      PagoTarjeta(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        banco: widget.banco,
        monto: monto,
        fecha: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pago TC ${widget.banco}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Deuda actual: S/ ${widget.deudaActual.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: montoController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(fontSize: 32),
              decoration: const InputDecoration(
                labelText: 'Monto pagado',
                prefixText: 'S/ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: registrarPago,
                child: const Text('Registrar pago'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrarRuleteoScreen extends StatefulWidget {
  final List<TarjetaCredito> tarjetas;

  const RegistrarRuleteoScreen({
    super.key,
    required this.tarjetas,
  });

  @override
  State<RegistrarRuleteoScreen> createState() => _RegistrarRuleteoScreenState();
}

class _RegistrarRuleteoScreenState extends State<RegistrarRuleteoScreen> {
  final montoController = TextEditingController();

  String? bancoOrigen;
  String? bancoDestino;

  double get monto {
    return double.tryParse(montoController.text.replaceAll(',', '.')) ?? 0;
  }

  double get comision {
    return monto * 0.01;
  }

  void guardarRuleteo() {
    if (bancoOrigen == null ||
        bancoDestino == null ||
        bancoOrigen == bancoDestino ||
        monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa origen, destino y monto válido.'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      Ruleteo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        bancoOrigen: bancoOrigen!,
        bancoDestino: bancoDestino!,
        monto: monto,
        comision: comision,
        fecha: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tarjetasDestino =
        widget.tarjetas.where((t) => t.banco != bancoOrigen).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Ruleteo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Tarjeta origen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.tarjetas.map((tarjeta) {
                final color = colorBanco(tarjeta.banco);

                return ChoiceChip(
                  label: Text(tarjeta.banco),
                  selected: bancoOrigen == tarjeta.banco,
                  selectedColor: color.withOpacity(0.25),
                  onSelected: (_) {
                    setState(() {
                      bancoOrigen = tarjeta.banco;
                      bancoDestino = null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: montoController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 28),
              decoration: const InputDecoration(
                labelText: 'Monto a ruletear',
                prefixText: 'S/ ',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 15),
            Card(
              child: ListTile(
                title: const Text('Comisión 1%'),
                trailing: Text('S/ ${comision.toStringAsFixed(2)}'),
              ),
            ),
            const SizedBox(height: 25),
            if (bancoOrigen != null) ...[
              const Text(
                'Tarjeta destino / pago',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: tarjetasDestino.map((tarjeta) {
                  final color = colorBanco(tarjeta.banco);

                  return ChoiceChip(
                    label: Text(tarjeta.banco),
                    selected: bancoDestino == tarjeta.banco,
                    selectedColor: color.withOpacity(0.25),
                    onSelected: (_) {
                      setState(() {
                        bancoDestino = tarjeta.banco;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: guardarRuleteo,
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Guardar ruleteo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== HISTORIAL =====================

class HistorialScreen extends StatelessWidget {
  final List<Gasto> gastos;
  final List<Ingreso> ingresos;
  final List<PagoTarjeta> pagosTarjeta;
  final List<Ruleteo> ruleteos;
  final List<PagoPrestamo> pagosPrestamo;
  final Future<void> Function(String tipo, String id) onEliminar;

  const HistorialScreen({
    super.key,
    required this.gastos,
    required this.ingresos,
    required this.pagosTarjeta,
    required this.ruleteos,
    required this.pagosPrestamo,
    required this.onEliminar,
  });

  Future<void> confirmarEliminar(
    BuildContext context,
    String tipo,
    String id,
    String titulo,
    double monto,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar movimiento'),
          content: Text(
            '¿Deseas eliminar?\n\n$titulo\nS/ ${monto.toStringAsFixed(2)}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await onEliminar(tipo, id);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final movimientos = [
      ...gastos.map((g) => {
            'id': g.id,
            'tipo': 'gasto',
            'monto': g.monto,
            'titulo': g.bancoTarjeta == null
                ? '${g.categoria} - ${g.medioPago}'
                : '${g.categoria} - ${g.medioPago} ${g.bancoTarjeta}',
            'fecha': g.fecha,
          }),
      ...ingresos.map((i) => {
            'id': i.id,
            'tipo': 'ingreso',
            'monto': i.monto,
            'titulo': i.tipo,
            'fecha': i.fecha,
          }),
      ...pagosTarjeta.map((p) => {
            'id': p.id,
            'tipo': 'pago_tc',
            'monto': p.monto,
            'titulo': 'Pago TC ${p.banco}',
            'fecha': p.fecha,
          }),
      ...ruleteos.map((r) => {
            'id': r.id,
            'tipo': 'ruleteo',
            'monto': r.comision,
            'titulo':
                'Ruleteo ${r.bancoOrigen} → ${r.bancoDestino} | Comisión',
            'fecha': r.fecha,
          }),
      ...pagosPrestamo.map((p) => {
            'id': p.id,
            'tipo': 'pago_prestamo',
            'monto': p.monto,
            'titulo': p.tipo == 'CAPITAL'
                ? 'Pago a capital préstamo'
                : 'Pago cuota préstamo',
            'fecha': p.fecha,
          }),
    ];

    movimientos.sort((a, b) {
      final fechaA = a['fecha'] as DateTime;
      final fechaB = b['fecha'] as DateTime;
      return fechaB.compareTo(fechaA);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Historial completo')),
      body: movimientos.isEmpty
          ? const Center(child: Text('No hay movimientos'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: movimientos.length,
              itemBuilder: (context, index) {
                final mov = movimientos[index];
                final id = mov['id'] as String;
                final tipo = mov['tipo'] as String;
                final esIngreso = tipo == 'ingreso';
                final esPagoTc = tipo == 'pago_tc';
                final esRuleteo = tipo == 'ruleteo';
                final monto = mov['monto'] as double;
                final titulo = mov['titulo'] as String;
                final fecha = mov['fecha'] as DateTime;

                return Card(
                  child: ListTile(
                    onLongPress: () {
                      confirmarEliminar(
                        context,
                        tipo,
                        id,
                        titulo,
                        monto,
                      );
                    },
                    title: Text(titulo),
                    subtitle: Text(
                      '${fecha.day}/${fecha.month}/${fecha.year} · Mantén presionado para eliminar',
                    ),
                    trailing: Text(
                      esPagoTc
                          ? 'Pago S/ ${monto.toStringAsFixed(2)}'
                          : esRuleteo
                              ? '- S/ ${monto.toStringAsFixed(2)}'
                              : '${esIngreso ? '+' : '-'} S/ ${monto.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: esIngreso || esPagoTc
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}


// ===================== PRESUPUESTOS Y DASHBOARD =====================

class PresupuestosScreen extends StatefulWidget {
  final List<PresupuestoCategoria> presupuestos;
  final List<Gasto> gastos;
  final Future<void> Function(List<PresupuestoCategoria> presupuestos) onGuardar;

  const PresupuestosScreen({
    super.key,
    required this.presupuestos,
    required this.gastos,
    required this.onGuardar,
  });

  @override
  State<PresupuestosScreen> createState() => _PresupuestosScreenState();
}

class _PresupuestosScreenState extends State<PresupuestosScreen> {
  late Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    final actuales = {
      for (final p in widget.presupuestos) p.categoria: p.montoMensual,
    };
    controllers = {
      for (final c in categoriasBase)
        c: TextEditingController(
          text: (actuales[c] ?? 0) == 0 ? '' : (actuales[c] ?? 0).toStringAsFixed(2),
        ),
    };
  }

  double gastadoMes(String categoria) {
    final hoy = DateTime.now();
    return widget.gastos
        .where((g) =>
            g.categoria == categoria &&
            g.fecha.year == hoy.year &&
            g.fecha.month == hoy.month)
        .fold(0.0, (suma, g) => suma + g.monto);
  }

  Future<void> guardar() async {
    final lista = <PresupuestoCategoria>[];
    for (final categoria in categoriasBase) {
      final valor = double.tryParse(
            controllers[categoria]!.text.replaceAll(',', '.'),
          ) ??
          0;
      lista.add(PresupuestoCategoria(categoria: categoria, montoMensual: valor));
    }
    await widget.onGuardar(lista);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presupuesto por categoría')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7567FF), Color(0xFF9F8CFF)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              'Define cuánto quieres gastar como máximo este mes. La app te avisará cuando estés cerca del límite o cuando te pases.',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 18),
          ...categoriasBase.map((categoria) {
            final gastado = gastadoMes(categoria);
            final presupuesto = double.tryParse(
                  controllers[categoria]!.text.replaceAll(',', '.'),
                ) ??
                0;
            final restante = presupuesto - gastado;
            final usado = presupuesto <= 0 ? 0.0 : (gastado / presupuesto).clamp(0.0, 1.0);
            final excedido = presupuesto > 0 && restante < 0;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(iconosCategoria[categoria] ?? '📦', style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            categoria,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controllers[categoria],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Presupuesto mensual',
                        prefixText: 'S/ ',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: usado,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      color: excedido ? const Color(0xFFD64545) : const Color(0xFF7567FF),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      presupuesto <= 0
                          ? 'Sin presupuesto asignado.'
                          : excedido
                              ? '😢 Has consumido S/ ${restante.abs().toStringAsFixed(2)} de más.'
                              : 'Te queda S/ ${restante.toStringAsFixed(2)} pendiente para gastar.',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: excedido ? const Color(0xFFD64545) : const Color(0xFF0B5D3B),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 14),
          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: guardar,
              icon: const Icon(Icons.save),
              label: const Text('Guardar presupuestos'),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCategoriasScreen extends StatelessWidget {
  final List<Gasto> gastos;
  final List<PresupuestoCategoria> presupuestos;

  const DashboardCategoriasScreen({
    super.key,
    required this.gastos,
    required this.presupuestos,
  });

  double gastadoMes(String categoria) {
    final hoy = DateTime.now();
    return gastos
        .where((g) =>
            g.categoria == categoria &&
            g.fecha.year == hoy.year &&
            g.fecha.month == hoy.month)
        .fold(0.0, (suma, g) => suma + g.monto);
  }

  double presupuestoDe(String categoria) {
    final match = presupuestos.where((p) => p.categoria == categoria);
    if (match.isEmpty) return 0;
    return match.first.montoMensual;
  }

  @override
  Widget build(BuildContext context) {
    final total = categoriasBase.fold(0.0, (suma, c) => suma + gastadoMes(c));

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de gastos')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7567FF), Color(0xFF9F8CFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Gasto del mes', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 6),
                Text(
                  'S/ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...categoriasBase.map((categoria) {
            final gastado = gastadoMes(categoria);
            final presupuesto = presupuestoDe(categoria);
            final base = presupuesto > 0 ? presupuesto : (total == 0 ? 1 : total);
            final porcentaje = (gastado / base).clamp(0.0, 1.0);
            final restante = presupuesto - gastado;
            final excedido = presupuesto > 0 && restante < 0;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(iconosCategoria[categoria] ?? '📦', style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            categoria,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                          ),
                        ),
                        Text(
                          'S/ ${gastado.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: porcentaje,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      color: excedido ? const Color(0xFFD64545) : const Color(0xFF7567FF),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      presupuesto <= 0
                          ? 'Sin presupuesto configurado.'
                          : excedido
                              ? '😢 Has consumido S/ ${restante.abs().toStringAsFixed(2)} de más de tu presupuesto.'
                              : 'Te queda S/ ${restante.toStringAsFixed(2)} para gastar este mes.',
                      style: TextStyle(
                        color: excedido ? const Color(0xFFD64545) : Colors.grey.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ===================== REGISTRO GASTO / INGRESO =====================


class RegistrarGastoScreen extends StatefulWidget {
  final List<TarjetaCredito> tarjetas;
  final List<Gasto> gastos;
  final Map<String, double> presupuestos;
  final double puedesGastarHoy;

  const RegistrarGastoScreen({
    super.key,
    required this.tarjetas,
    required this.gastos,
    required this.presupuestos,
    required this.puedesGastarHoy,
  });

  @override
  State<RegistrarGastoScreen> createState() => _RegistrarGastoScreenState();
}

class _RegistrarGastoScreenState extends State<RegistrarGastoScreen> {
  final TextEditingController montoController = TextEditingController();

  String? categoriaSeleccionada;
  String? medioPagoSeleccionado;

  final categorias = const [
    {'nombre': 'Consumo', 'icono': '🍔'},
    {'nombre': 'Transporte', 'icono': '🚕'},
    {'nombre': 'Compras', 'icono': '🛒'},
    {'nombre': 'Ocio', 'icono': '🎉'},
    {'nombre': 'Otros', 'icono': '📦'},
  ];

  double montoActual() {
    return double.tryParse(montoController.text.replaceAll(',', '.')) ?? 0;
  }

  double gastadoMesCategoria(String categoria) {
    final hoy = DateTime.now();
    return widget.gastos
        .where((g) =>
            g.categoria == categoria &&
            g.fecha.year == hoy.year &&
            g.fecha.month == hoy.month)
        .fold(0.0, (suma, g) => suma + g.monto);
  }

  Future<bool> confirmarAlerta({
    required String titulo,
    required String mensaje,
    required IconData icono,
    required Color color,
  }) async {
    final continuar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(icono, color: color),
            const SizedBox(width: 8),
            Expanded(child: Text(titulo)),
          ],
        ),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );

    return continuar == true;
  }

  Future<void> registrarGasto(String medioPago, {String? bancoTarjeta}) async {
    final monto = montoActual();
    if (monto <= 0 || categoriaSeleccionada == null) return;

    if (widget.puedesGastarHoy > 0 && monto > widget.puedesGastarHoy) {
      final continuar = await confirmarAlerta(
        titulo: 'Cuidado con tu gasto diario',
        mensaje:
            'Este gasto supera lo recomendable para hoy. Puedes gastar hoy S/ ${widget.puedesGastarHoy.toStringAsFixed(2)} y estás intentando gastar S/ ${monto.toStringAsFixed(2)}.',
        icono: Icons.warning_amber_rounded,
        color: const Color(0xFFFF9800),
      );
      if (!continuar) return;
    }

    final categoria = categoriaSeleccionada!;
    final presupuesto = widget.presupuestos[categoria] ?? 0;
    if (presupuesto > 0) {
      final gastadoActual = gastadoMesCategoria(categoria);
      final restanteAntes = presupuesto - gastadoActual;
      final restanteDespues = presupuesto - gastadoActual - monto;

      if (restanteDespues >= 0) {
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Presupuesto controlado 💪'),
            content: Text(
              'Después de este gasto te quedarán S/ ${restanteDespues.toStringAsFixed(2)} para $categoria este mes. Recuerda: ahorrar también es pagarte a ti mismo.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
      } else {
        final exceso = restanteDespues.abs();
        final continuar = await confirmarAlerta(
          titulo: 'Te pasaste del presupuesto 😢',
          mensaje:
              'Ya no queda presupuesto suficiente para $categoria. Te excederás en S/ ${exceso.toStringAsFixed(2)}. Antes de continuar, piensa si este gasto es realmente necesario.',
          icono: Icons.sentiment_dissatisfied_rounded,
          color: const Color(0xFFD64545),
        );
        if (!continuar) return;
      }

      if (restanteAntes > 0 && restanteAntes <= presupuesto * 0.2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Te quedaba poco presupuesto en $categoria: S/ ${restanteAntes.toStringAsFixed(2)}.',
            ),
          ),
        );
      }
    }

    if (!mounted) return;
    Navigator.pop(
      context,
      Gasto(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        monto: monto,
        categoria: categoria,
        medioPago: medioPago,
        bancoTarjeta: bancoTarjeta,
        fecha: DateTime.now(),
      ),
    );
  }

  Widget presupuestoPreview() {
    if (categoriaSeleccionada == null) return const SizedBox.shrink();
    final categoria = categoriaSeleccionada!;
    final presupuesto = widget.presupuestos[categoria] ?? 0;
    if (presupuesto <= 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Text('Esta categoría aún no tiene presupuesto mensual.'),
        ),
      );
    }

    final gastado = gastadoMesCategoria(categoria);
    final restante = presupuesto - gastado - montoActual();
    final usado = presupuesto <= 0 ? 0.0 : ((gastado + montoActual()) / presupuesto).clamp(0.0, 1.0);
    final excedido = restante < 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              excedido
                  ? '😢 Te excederías S/ ${restante.abs().toStringAsFixed(2)}'
                  : 'Te quedará S/ ${restante.toStringAsFixed(2)} para $categoria',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: excedido ? const Color(0xFFD64545) : const Color(0xFF0B5D3B),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: usado,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: excedido ? const Color(0xFFD64545) : const Color(0xFF7567FF),
              borderRadius: BorderRadius.circular(99),
            ),
            const SizedBox(height: 6),
            Text('Presupuesto: S/ ${presupuesto.toStringAsFixed(2)} · Gastado: S/ ${gastado.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final montoIngresado = montoController.text.trim().isNotEmpty;

    final mediosPago = [
      {'nombre': 'Yape', 'icono': '🟣'},
      {'nombre': 'Efectivo', 'icono': '💵'},
      if (widget.tarjetas.isNotEmpty) {'nombre': 'Tarjeta', 'icono': '💳'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar gasto')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '¿Cuánto gastaste?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: montoController,
            keyboardType: TextInputType.number,
            autofocus: true,
            style: const TextStyle(fontSize: 32),
            decoration: const InputDecoration(
              prefixText: 'S/ ',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 25),
          if (montoIngresado) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Categoría',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categorias.map((cat) {
                final nombre = cat['nombre']!;
                final icono = cat['icono']!;

                return ChoiceChip(
                  label: Text('$icono $nombre'),
                  selected: categoriaSeleccionada == nombre,
                  onSelected: (_) {
                    setState(() {
                      categoriaSeleccionada = nombre;
                      medioPagoSeleccionado = null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            presupuestoPreview(),
          ],
          const SizedBox(height: 25),
          if (categoriaSeleccionada != null) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Medio de pago',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: mediosPago.map((medio) {
                final nombre = medio['nombre']!;
                final icono = medio['icono']!;

                return ElevatedButton(
                  onPressed: () {
                    if (nombre == 'Tarjeta') {
                      setState(() {
                        medioPagoSeleccionado = 'Tarjeta';
                      });
                    } else {
                      registrarGasto(nombre);
                    }
                  },
                  child: Text('$icono $nombre'),
                );
              }).toList(),
            ),
          ],
          if (medioPagoSeleccionado == 'Tarjeta') ...[
            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Selecciona tarjeta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.tarjetas.map((tarjeta) {
                final color = colorBanco(tarjeta.banco);

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    registrarGasto(
                      'Tarjeta',
                      bancoTarjeta: tarjeta.banco,
                    );
                  },
                  child: Text(tarjeta.banco),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class RegistrarIngresoScreen extends StatefulWidget {
  const RegistrarIngresoScreen({super.key});

  @override
  State<RegistrarIngresoScreen> createState() => _RegistrarIngresoScreenState();
}

class _RegistrarIngresoScreenState extends State<RegistrarIngresoScreen> {
  final TextEditingController montoController = TextEditingController();

  final tiposIngreso = const [
    {'nombre': 'Sueldo', 'icono': '💼'},
    {'nombre': 'Comisión', 'icono': '🎯'},
    {'nombre': 'Extra', 'icono': '💸'},
    {'nombre': 'Otro', 'icono': '📦'},
  ];

  void registrarIngreso(String tipo) {
    final monto = double.tryParse(montoController.text.replaceAll(',', '.'));
    if (monto == null || monto <= 0) return;

    Navigator.pop(
      context,
      Ingreso(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        monto: monto,
        tipo: tipo,
        fecha: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final montoIngresado = montoController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar ingreso')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '¿Cuánto recibiste?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: montoController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(fontSize: 32),
              decoration: const InputDecoration(
                prefixText: 'S/ ',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 25),
            if (montoIngresado) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tipo de ingreso',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: tiposIngreso.map((tipo) {
                  final nombre = tipo['nombre']!;
                  final icono = tipo['icono']!;

                  return ElevatedButton(
                    onPressed: () => registrarIngreso(nombre),
                    child: Text('$icono $nombre'),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}