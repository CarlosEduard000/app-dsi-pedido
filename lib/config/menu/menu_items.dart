import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Iniciar',
    subTitle: '',
    link: '/list_order',
    icon: Icons.storefront_outlined,
  ),

  MenuItem(
    title: 'Catálogo',
    subTitle: '',
    link: '/article_catalog',
    icon: Icons.inventory_2_outlined,
  ),

  MenuItem(
    title: 'Pedido',
    subTitle: '',
    link: '/cart_screen',
    icon: Icons.shopping_cart_outlined,
  ),
];
