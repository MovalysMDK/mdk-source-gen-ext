<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="controller[count(saveActionNames/saveActionName) = 1 and not(isInContainerViewController='true')]" mode="do-keep-modifications">
	
- (void) doOnKeepModification:(id)sender {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">doOnKeepModification</xsl:with-param>
		<xsl:with-param name="defaultSource">
    	[[MFApplication getInstance] launchAction:MFAction_<xsl:value-of select="saveActionNames/saveActionName"/> withCaller:self withInParameter:nil];		
		</xsl:with-param>
	</xsl:call-template> 
}

MFRegister_ActionListenerOnMyLaunchedActionSuccess(MFAction_<xsl:value-of select="saveActionNames/saveActionName"/>, succeedSaveAction)
- (void) succeedSaveAction:(id&lt;MFContextProtocol&gt;)context withCaller:(id)caller andResult:(id)result {
	if ([caller isEqual:self]) {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">succeedSaveAction</xsl:with-param>
		<xsl:with-param name="defaultSource">
		[self.viewModel resetChanged];
		[[MFApplication getInstance] execInMainQueue:^{
	        [self.navigationController popViewControllerAnimated:YES];
	    }];
		</xsl:with-param>
	</xsl:call-template> 
	}
}


MFRegister_ActionListenerOnMyLaunchedActionFailed(MFAction_<xsl:value-of select="saveActionNames/saveActionName"/>, failedSaveAction)
- (void) failedSaveAction:(id&lt;MFContextProtocol&gt;)context withCaller:(id)caller andResult:(id)result {
	if ([caller isEqual:self]) {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">failedSaveAction</xsl:with-param>
		<xsl:with-param name="defaultSource">
    		[[MFApplication getInstance] execInMainQueue:^{
        	UIAlertView *errorAlert = [[UIAlertView alloc]
        		initWithTitle:MFLocalizedStringFromKey(@"form_savefailed_title")
            	message:MFLocalizedStringFromKey(@"form_savefailed_message")
            	delegate:nil cancelButtonTitle:MFLocalizedStringFromKey(@"form_savefailed_ok")
            	otherButtonTitles:nil, nil];
        	[errorAlert show];
    		}];			
		</xsl:with-param>
	</xsl:call-template> 
	}
}
</xsl:template>




<xsl:template match="controller[count(saveActionNames/saveActionName) &gt; 1 and not(isInContainerViewController='true')]" mode="do-keep-modifications">

	
- (void) doOnKeepModification:(id)sender {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">succeedSaveAction</xsl:with-param>
		<xsl:with-param name="defaultSource">
    	MFChainSaveActionDetailParameter *inParameter = [[MFChainSaveActionDetailParameter alloc] init];
    	<xsl:for-each select="saveActionNames/saveActionName">
    	[inParameter.actions addObject:@"<xsl:value-of select="."/>"];
    	</xsl:for-each>
    	[[MFApplication getInstance] launchAction:@"MFChainSaveDetailAction" withCaller:self withInParameter:inParameter];	
		</xsl:with-param>
	</xsl:call-template> 
}

MFRegister_ActionListenerOnMyLaunchedActionSuccess(MFAction_MFChainSaveDetailAction, succeedSaveAction)
- (void) succeedSaveAction:(id&lt;MFContextProtocol&gt;)context withCaller:(id)caller andResult:(id)result {
	if ([caller isEqual:self]) {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">succeedSaveAction</xsl:with-param>
		<xsl:with-param name="defaultSource">
		[self.viewModel resetChanged];
		[[MFApplication getInstance] execInMainQueue:^{
        	[self.navigationController popViewControllerAnimated:YES];
    	}];		
		</xsl:with-param>
	</xsl:call-template> 
	}
}


MFRegister_ActionListenerOnMyLaunchedActionFailed(MFAction_MFChainSaveDetailAction, failedSaveAction)
- (void) failedSaveAction:(id&lt;MFContextProtocol&gt;)context withCaller:(id)caller andResult:(id)result {
	if ([caller isEqual:self]) {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">failedSaveAction</xsl:with-param>
		<xsl:with-param name="defaultSource">
    		[[MFApplication getInstance] execInMainQueue:^{
        	UIAlertView *errorAlert = [[UIAlertView alloc]
        		initWithTitle:MFLocalizedStringFromKey(@"form_savefailed_title")
            	message:MFLocalizedStringFromKey(@"form_savefailed_message")
            	delegate:nil cancelButtonTitle:MFLocalizedStringFromKey(@"form_savefailed_ok")
            	otherButtonTitles:nil, nil];
        	[errorAlert show];
    		}];			
		</xsl:with-param>
	</xsl:call-template> 
	}
}

</xsl:template>

<xsl:template match="controller" mode="do-keep-modifications"/>

</xsl:stylesheet>
