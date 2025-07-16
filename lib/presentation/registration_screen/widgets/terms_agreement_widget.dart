import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAgreementWidget extends StatefulWidget {
  final Function(bool termsAccepted, bool privacyAccepted) onAgreementChanged;
  final bool initialTermsAccepted;
  final bool initialPrivacyAccepted;

  const TermsAgreementWidget({
    super.key,
    required this.onAgreementChanged,
    this.initialTermsAccepted = false,
    this.initialPrivacyAccepted = false,
  });

  @override
  State<TermsAgreementWidget> createState() => _TermsAgreementWidgetState();
}

class _TermsAgreementWidgetState extends State<TermsAgreementWidget> {
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  @override
  void initState() {
    super.initState();
    _termsAccepted = widget.initialTermsAccepted;
    _privacyAccepted = widget.initialPrivacyAccepted;
  }

  void _updateAgreement() {
    widget.onAgreementChanged(_termsAccepted, _privacyAccepted);
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Terms of Service',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          content: SizedBox(
            height: 50.h,
            width: 80.w,
            child: SingleChildScrollView(
              child: Text(
                _getTermsOfServiceText(),
                style: GoogleFonts.inter(fontSize: 14),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Privacy Policy',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          content: SizedBox(
            height: 50.h,
            width: 80.w,
            child: SingleChildScrollView(
              child: Text(
                _getPrivacyPolicyText(),
                style: GoogleFonts.inter(fontSize: 14),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agreement',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 3.h),
        _buildTermsCheckbox(),
        SizedBox(height: 2.h),
        _buildPrivacyCheckbox(),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return CheckboxListTile(
      value: _termsAccepted,
      onChanged: (value) {
        setState(() {
          _termsAccepted = value ?? false;
          _updateAgreement();
        });
      },
      contentPadding: EdgeInsets.zero,
      title: RichText(
        text: TextSpan(
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          children: [
            const TextSpan(text: 'I agree to the '),
            WidgetSpan(
              child: GestureDetector(
                onTap: _showTermsDialog,
                child: Text(
                  'Terms of Service',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyCheckbox() {
    return CheckboxListTile(
      value: _privacyAccepted,
      onChanged: (value) {
        setState(() {
          _privacyAccepted = value ?? false;
          _updateAgreement();
        });
      },
      contentPadding: EdgeInsets.zero,
      title: RichText(
        text: TextSpan(
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          children: [
            const TextSpan(text: 'I agree to the '),
            WidgetSpan(
              child: GestureDetector(
                onTap: _showPrivacyDialog,
                child: Text(
                  'Privacy Policy',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTermsOfServiceText() {
    return '''
LOOP GOLF TERMS OF SERVICE

Last updated: ${DateTime.now().year}

1. ACCEPTANCE OF TERMS
By accessing and using the Loop Golf mobile application, you accept and agree to be bound by the terms and provision of this agreement.

2. DESCRIPTION OF SERVICE
Loop Golf is a mobile application designed to help golfers connect, track their games, participate in tournaments, and navigate golf courses.

3. USER ACCOUNTS
You are responsible for maintaining the confidentiality of your account and password and for restricting access to your device.

4. USER CONDUCT
You agree not to use the service to:
- Upload, post, or transmit any content that is unlawful, harmful, threatening, abusive, harassing, defamatory, vulgar, obscene, or otherwise objectionable
- Impersonate any person or entity
- Interfere with or disrupt the service or servers

5. GOLF HANDICAP AND SCORING
- Handicap information provided through the app is for recreational purposes
- Official handicap verification may require GHIN integration
- Score tracking is provided as a convenience feature

6. PRIVACY AND DATA PROTECTION
Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your information.

7. LIMITATION OF LIABILITY
Loop Golf shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of the service.

8. MODIFICATIONS
We reserve the right to modify these terms at any time. Users will be notified of significant changes.

9. GOVERNING LAW
These terms shall be governed by and construed in accordance with applicable laws.

10. CONTACT INFORMATION
For questions about these Terms of Service, please contact our support team through the app.

By creating an account, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.
''';
  }

  String _getPrivacyPolicyText() {
    return '''
LOOP GOLF PRIVACY POLICY

Last updated: ${DateTime.now().year}

1. INFORMATION WE COLLECT
We collect information you provide directly to us, such as:
- Account information (name, email, password)
- Golf-related information (handicap, home course, playing frequency)
- Profile photos and preferences
- Score and game tracking data

2. HOW WE USE YOUR INFORMATION
We use the information we collect to:
- Provide, maintain, and improve our services
- Process transactions and send related information
- Send you technical notices and support messages
- Respond to your comments and questions
- Facilitate social features and tournaments

3. INFORMATION SHARING
We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except:
- To comply with legal obligations
- To protect our rights and safety
- With service providers who assist in our operations

4. DATA SECURITY
We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.

5. LOCATION INFORMATION
With your permission, we may collect location data to:
- Provide GPS course navigation
- Suggest nearby golf courses
- Enhance tournament and social features

6. SOCIAL FEATURES
Our app includes social features that allow you to:
- Connect with other golfers
- Share scores and achievements
- Participate in tournaments and leaderboards

7. DATA RETENTION
We retain your information for as long as your account is active or as needed to provide services, comply with legal obligations, and resolve disputes.

8. YOUR CHOICES
You can:
- Access and update your account information
- Control location sharing settings
- Manage social feature preferences
- Delete your account and associated data

9. CHILDREN'S PRIVACY
Our service is not intended for children under 13. We do not knowingly collect personal information from children under 13.

10. CHANGES TO THIS POLICY
We may update this Privacy Policy from time to time. We will notify users of any material changes through the app or email.

11. CONTACT US
If you have questions about this Privacy Policy, please contact our support team through the app.

By using Loop Golf, you consent to the collection and use of your information as described in this Privacy Policy.
''';
  }
}
