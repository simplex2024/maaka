// import 'package:flutter/material.dart';
//
// class InfoCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String message;
//   final String? buttonText;
//   final VoidCallback? onPressed;
//   final Color backgroundColor;
//
//   const InfoCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.message,
//     this.buttonText,
//     this.onPressed,
//     this.backgroundColor = const Color(0xFFF5F5F5),
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: backgroundColor,
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.blue.shade100,
//                   child: Icon(icon, color: Colors.blue),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Text(
//               message,
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             if (buttonText != null && onPressed != null) ...[
//               const SizedBox(height: 16),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton(
//                   onPressed: onPressed,
//                   child: Text(buttonText!),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:maaakanmoney/components/constants.dart';

class BusinessInviteBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? bannerImageUrl;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final VoidCallback? onEnquiryPressed;
  final Color backgroundColor;

  const BusinessInviteBanner({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.bannerImageUrl,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.onEnquiryPressed,
    this.backgroundColor = const Color(0xFFF0F4FF),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Constants.secondary,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((bannerImageUrl ?? "").isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  bannerImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(icon, color: Colors.blue, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Encode Sans Condensed',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.5,
                fontFamily: 'Encode Sans Condensed',
              ),
            ),

            // Enquiry Request Button
            if (onEnquiryPressed != null) ...[
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onEnquiryPressed,
                  icon: const Icon(Icons.mail_outline),
                  label: const Text("Send Enquiry Request"),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (secondaryButtonText != null && onSecondaryPressed != null)
                  ElevatedButton(
                    onPressed: onSecondaryPressed,
                    child: Text(secondaryButtonText!),
                  ),
                const SizedBox(width: 12),
                if (primaryButtonText != null && onPrimaryPressed != null)
                  ElevatedButton(
                    onPressed: onPrimaryPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text(primaryButtonText!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
