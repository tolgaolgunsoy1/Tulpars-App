import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../bloc/auth/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // TODO: Load user profile data
    _nameController.text = 'Ahmet Yılmaz';
    _emailController.text = 'ahmet@email.com';
    _phoneController.text = '+90 555 123 4567';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Save profile changes
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isEditing = false);
      _showSnackBar('Profil güncellendi');
    } catch (e) {
      _showSnackBar('Profil güncellenirken hata oluştu');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'), content: const Text(
            'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?',), actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), child: const Text('İptal'),),TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(SignOutRequested());
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(AppConstants.secondaryColor)), child: const Text('Çıkış Yap'),),],),);}

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message) backgroundColor: const Color(AppConstants.successColor) behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),),);}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC) appBar: AppBar(
        backgroundColor: const Color(AppConstants.primaryColor) elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,),), centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit) onPressed: _isEditing ? _toggleEdit : _toggleEdit,
            color: Colors.white,),],), body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24) child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              _buildProfilePicture(),

              const SizedBox(height: 24)// Profile Info
              _buildProfileInfo(),

              const SizedBox(height: 32)// Menu Items
              _buildMenuItems(),

              const SizedBox(height: 32)// Logout Button
              _buildLogoutButton(),],),),),);}

  Widget _buildProfilePicture() {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(AppConstants.primaryColor)Color(AppConstants.primaryLightColor)],), boxShadow: [
              BoxShadow(
                color: const Color(AppConstants.primaryColor)
                    .withValues(alpha: 0.3) blurRadius: 20,
                offset: const Offset(0, 8)),],), child: const CircleAvatar(
            radius: 58,
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.white,),),),if (_isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8) decoration: const BoxDecoration(
                color: Color(AppConstants.primaryColor) shape: BoxShape.circle,), child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,),),),],);}

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(24) decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16) boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05) blurRadius: 10,
            offset: const Offset(0, 2)),],), child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            enabled: _isEditing,
            decoration: InputDecoration(
              labelText: 'Ad Soyad',
              prefixIcon:
                  const Icon(Icons.person_outline, color: Color(0xFF64748B)), border: _isEditing ? null : InputBorder.none,
              enabledBorder: _isEditing ? null : InputBorder.none,
              focusedBorder: _isEditing ? null : InputBorder.none,
              filled: !_isEditing,
              fillColor: _isEditing ? null : Colors.grey.shade50,),),const Divider(height: 24)TextFormField(
            controller: _emailController,
            enabled: _isEditing,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'E-posta',
              prefixIcon:
                  const Icon(Icons.email_outlined, color: Color(0xFF64748B)), border: _isEditing ? null : InputBorder.none,
              enabledBorder: _isEditing ? null : InputBorder.none,
              focusedBorder: _isEditing ? null : InputBorder.none,
              filled: !_isEditing,
              fillColor: _isEditing ? null : Colors.grey.shade50,),),const Divider(height: 24)TextFormField(
            controller: _phoneController,
            enabled: _isEditing,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Telefon',
              prefixIcon:
                  const Icon(Icons.phone_outlined, color: Color(0xFF64748B)), border: _isEditing ? null : InputBorder.none,
              enabledBorder: _isEditing ? null : InputBorder.none,
              focusedBorder: _isEditing ? null : InputBorder.none,
              filled: !_isEditing,
              fillColor: _isEditing ? null : Colors.grey.shade50,),),if (_isEditing) ...[
            const SizedBox(height: 24)Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _toggleEdit,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF64748B)), shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),), child: const Text('İptal'),),),const SizedBox(width: 12)Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(AppConstants.primaryColor) shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),), child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white)),),
                        : const Text('Kaydet'),),),],),],],),);}

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Bildirimler',
          subtitle: 'Bildirim ayarları',
          onTap: () {
            // TODO: Navigate to notifications settings
          },),_buildMenuItem(
          icon: Icons.security,
          title: 'Güvenlik',
          subtitle: 'Şifre değiştirme',
          onTap: () {
            // TODO: Navigate to security settings
          },),_buildMenuItem(
          icon: Icons.help_outline,
          title: 'Yardım & Destek',
          subtitle: 'SSS ve destek',
          onTap: () {
            // TODO: Navigate to help screen
          },),_buildMenuItem(
          icon: Icons.info_outline,
          title: 'Hakkında',
          subtitle: 'Uygulama bilgileri',
          onTap: () {
            // TODO: Navigate to about screen
          },),],);}

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,},) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8) decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12) boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05) blurRadius: 10,
            offset: const Offset(0, 2)),],), child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:
                const Color(AppConstants.primaryColor).withValues(alpha: 0.1) borderRadius: BorderRadius.circular(8)), child: Icon(
            icon,
            color: const Color(AppConstants.primaryColor)),), title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A)),), subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B)),), trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF64748B)), onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),),);}

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: _logout,
        icon: const Icon(
          Icons.logout,
          color: Color(AppConstants.secondaryColor)), label: const Text(
          'Çıkış Yap',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.secondaryColor)),), style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(AppConstants.secondaryColor)), shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),),),);}
}






