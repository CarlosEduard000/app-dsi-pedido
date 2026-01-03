import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/menu/menu_items.dart';
import '../../features/articles/presentation/presentation.dart';
import '../../features/auth/auth.dart';
import '../providers/providers.dart';
import 'custom_menu_action_tile.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SideMenu({super.key, required this.scaffoldKey});

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final colors = Theme.of(context).colorScheme;
    final isDark = ref.watch(themeNotifierProvider).isDarkmode;

    return Drawer(
      backgroundColor: colors.surface,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, hasNotch ? 50 : 40, 20, 20),
                  child: Image.asset(
                    'assets/images/fondo2.png',
                    height: 40,
                    alignment: Alignment.centerLeft,
                  ),
                ),

                ...appMenuItems.asMap().entries.map((entry) {
                  int idx = entry.key;
                  MenuItem item = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    child: CustomMenuActionTile(
                      icon: item.icon,
                      label: item.title,
                      isSelected: navDrawerIndex == idx,
                      onTap: () {
                        setState(() => navDrawerIndex = idx);
                        ref.read(selectedItemProvider.notifier).state = null;

                        context.push(item.link);
                        widget.scaffoldKey.currentState?.closeDrawer();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          Divider(height: 1, indent: 20, endIndent: 20, color: colors.outline),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INVERSIONES LA PASCANA S.A.C',
                  style: GoogleFonts.roboto(
                    color: colors.onSurfaceVariant,
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  '20503225923',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  'Almacen: Chimpu Ocllo',
                  style: GoogleFonts.roboto(
                    color: colors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 20),

                CustomMenuActionTile(
                  icon: isDark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  label: isDark ? 'Activar modo claro' : 'Activar modo oscuro',
                  onTap: () {
                    ref.read(selectedItemProvider.notifier).state = null;
                    ref.read(themeNotifierProvider.notifier).toggleDarkmode();
                  },
                ),

                CustomMenuActionTile(
                  icon: Icons.settings_outlined,
                  label: 'Modificar cliente',
                  onTap: () {
                    context.go('/client_selection_screen');
                  },
                ),

                CustomMenuActionTile(
                  icon: Icons.logout_outlined,
                  label: 'Cerrar sesión',
                  color: colors.error,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Cerrar sesión'),
                        content: const Text(
                          '¿Estás seguro de que deseas salir de la aplicación?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: colors.error,
                            ),
                            onPressed: () async {
                              ref.read(selectedItemProvider.notifier).state =
                                  null;
                              await ref.read(authProvider.notifier).logout();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                widget.scaffoldKey.currentState?.closeDrawer();
                                context.go('/welcome');
                              }
                            },
                            child: const Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 15),

                Text(
                  'DSI - Catálogo Virtual v. 0.0.1\n© 2026 Todos los derechos reservados.',
                  style: GoogleFonts.roboto(
                    fontSize: 10,
                    color: colors.outline,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
