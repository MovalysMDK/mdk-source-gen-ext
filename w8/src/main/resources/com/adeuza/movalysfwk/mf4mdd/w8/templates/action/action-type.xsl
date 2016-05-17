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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">
		

<xsl:template match="action-type[. ='SAVEDETAIL']" mode="action-interface">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Interface Class </xsl:text><xsl:value-of select="../name"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>		[ScopePolicyAttribute(ScopePolicy.Prototype)]&#13;</xsl:text>
	<xsl:text>		public interface </xsl:text><xsl:value-of select="../name"/><xsl:text> : IAction&lt;CUDActionArgs, CUDActionArgs&gt;</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>		{</xsl:text>
	<xsl:text>&#13;		}&#13;</xsl:text>
</xsl:template>


<xsl:template match="action-type[. ='SAVEDETAIL']" mode="action-chained-interface">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Interface Class ISaveChained</xsl:text><xsl:value-of select="../chained-action"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>		[ScopePolicyAttribute(ScopePolicy.Prototype)]&#13;</xsl:text>
	<xsl:text>		public interface ISaveChained</xsl:text><xsl:value-of select="../chained-action"/><xsl:text> : IAction&lt;ChainedActionArgs, ChainedActionArgs&gt;</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>		{</xsl:text>
	<xsl:text>&#13;		}&#13;</xsl:text>
</xsl:template>


<xsl:template match="action-type[. ='DELETEDETAIL']" mode="action-interface">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Interface Class </xsl:text><xsl:value-of select="../name"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>		[ScopePolicyAttribute(ScopePolicy.Prototype)]&#13;</xsl:text>
	<xsl:text>		public interface </xsl:text><xsl:value-of select="../name"/><xsl:text> : IAction&lt;CUDActionArgs, CUDActionArgs&gt;</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>		{</xsl:text>
	<xsl:text>&#13;		}&#13;</xsl:text>
</xsl:template>


<xsl:template match="action-type[. ='DELETEDETAIL']" mode="action-chained-interface">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Interface Class IDeleteChained</xsl:text><xsl:value-of select="../chained-action"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>		[ScopePolicyAttribute(ScopePolicy.Prototype)]&#13;</xsl:text>
	<xsl:text>		public interface IDeleteChained</xsl:text><xsl:value-of select="../chained-action"/><xsl:text> : IAction&lt;ChainedActionArgs, ChainedActionArgs&gt;</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>		{</xsl:text>
	<xsl:text>&#13;		}&#13;</xsl:text>
</xsl:template>


<xsl:template match="action-type[. ='SAVEDETAIL' and ../dao-interface]" mode="action-impl">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Class </xsl:text><xsl:value-of select="../name"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>public class </xsl:text><xsl:value-of select="../name"/>
	<xsl:text> : SaveAction&lt;</xsl:text><xsl:value-of select="../class/implements/interface/@name"/><xsl:text>,</xsl:text><xsl:value-of select="../dao-interface/name"/><xsl:text>&gt;, </xsl:text><xsl:value-of select="../implements/interface/@name"/>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>&#13;#region Methods&#13;</xsl:text>
	<xsl:text>/// &lt;inheritDoc /&gt;</xsl:text>       
	public override CUDActionArgs DoAction(CUDActionArgs parameterIn, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">PreSaveTreatment</xsl:with-param>
		</xsl:call-template>
	    <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">GenericSaveAction</xsl:with-param>
		</xsl:call-template>
		
		<!-- <xsl:apply-templates select="../viewmodel/savecascades" mode="cascades-set" /> -->
	    CUDActionArgs parameterOut = base.DoAction(parameterIn, context, actionQualifier, dispacher);
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">PostSaveTreatment</xsl:with-param>
		</xsl:call-template>
	
	    return (parameterOut);
	}
	
	 public override CascadeSet GetSaveCascadeSet()
	    {
	        <xsl:text>return </xsl:text><xsl:apply-templates select="../viewmodel/savecascades" mode="cascades-set" /><xsl:text>;</xsl:text>
	    }
	    
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	 public override void DoOnFailed(CUDActionArgs parameterOut, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">DoOnFailedSave</xsl:with-param>
	    </xsl:call-template>
	    
	    base.DoOnFailed(parameterOut, context, actionQualifier, dispacher);
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	 public override void DoOnSuccess(CUDActionArgs parameterOut, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">DoOnSuccessSave</xsl:with-param>
	   	</xsl:call-template>
	   	
	   	base.DoOnSuccess(parameterOut, context, actionQualifier, dispacher);
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	<xsl:text>public override void CompleteNewEntity(</xsl:text>
	<xsl:choose>
		<xsl:when test="/action/chained-action">
			<xsl:text>IMIdentifiable</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="/action/class/implements/interface/@name"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text> entity, IViewModel viewmodel, IMFContext context)</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>base.CompleteNewEntity(entity, viewmodel, context);</xsl:text>
	<xsl:apply-templates select="../class/association[@type='many-to-one']" mode="generate-method-call-completenewentity"/>
	<xsl:text>}&#13;</xsl:text>
	
	<xsl:apply-templates select="../class/association[@type='many-to-one']" mode="generate-method-completenewentity"/>
	
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template> 
	
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	<xsl:text>&#13;}&#13;</xsl:text>
</xsl:template>


<xsl:template match="action-type[. ='SAVEDETAIL' and not(../dao-interface)]" mode="action-impl">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Class </xsl:text><xsl:value-of select="../name"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>public class </xsl:text><xsl:value-of select="../name"/>
	<xsl:text> : SaveAction&lt;</xsl:text><xsl:value-of select="../class/implements/interface/@name"/>
	<xsl:text>&gt;, </xsl:text><xsl:value-of select="../implements/interface/@name"/>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>&#13;#region Methods&#13;</xsl:text>
	<xsl:text>/// &lt;inheritDoc /&gt;</xsl:text>       
	public override CUDActionArgs DoAction(CUDActionArgs parameterIn, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">PreSaveTreatment</xsl:with-param>
		</xsl:call-template>
	    <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">GenericSaveAction</xsl:with-param>
		</xsl:call-template>
		
		<xsl:text>CUDActionArgs </xsl:text><xsl:value-of select="../name"/><xsl:text>Args = base.DoAction(parameterIn, context, actionQualifier, dispacher);&#13;</xsl:text>
	 	
	 	<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">PostSaveTreatment</xsl:with-param>
		</xsl:call-template>
	 	
	 	<xsl:text>return </xsl:text><xsl:value-of select="../name"/><xsl:text>Args;</xsl:text>
	
		<xsl:text>}</xsl:text>
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	 public override void DoOnFailed(CUDActionArgs parameterOut, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">DoOnFailedSave</xsl:with-param>
	    </xsl:call-template>
	    
	    // base.DoOnFailed(parameterOut, context, actionQualifier, dispacher);
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	 public override void DoOnSuccess(CUDActionArgs parameterOut, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">DoOnSuccessSave</xsl:with-param>
	   	</xsl:call-template>
	   	
	   	// base.DoOnSuccess(parameterOut, context, actionQualifier, dispacher);
	}
	
	<!-- <xsl:apply-templates select="../class/association[@type='many-to-one']" mode="generate-method-completenewentity"/> -->
	
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template> 
	
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	<xsl:text>public bool isReadOnly
	    {
	        get
	        {
	            return true;
	        }
	        set
	        {
	            isReadOnly = true;
	        }
	    }</xsl:text>
	<xsl:text>&#13;}&#13;</xsl:text>
</xsl:template>


<xsl:template match="action-type[. ='SAVEDETAIL']" mode="action-chained-impl">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Class SaveChained</xsl:text><xsl:value-of select="../chained-action"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>public class SaveChained</xsl:text><xsl:value-of select="../chained-action"/>
	<xsl:text> : SaveChainAction&lt;IMIdentifiable&gt;, ISaveChained</xsl:text><xsl:value-of select="../chained-action"/>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>&#13;#region Methods&#13;</xsl:text>
	<xsl:text>/// &lt;inheritDoc /&gt;</xsl:text>       
	public override ChainedActionArgs DoAction(ChainedActionArgs parameterListIn, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">PreSaveTreatment</xsl:with-param>
		</xsl:call-template>
	    <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">GenericSaveAction</xsl:with-param>
		</xsl:call-template>
		
	    <!-- <xsl:text>&#13;foreach (CUDActionArgs parameterIn in parameterListIn.listCUDActionArgs)</xsl:text> 
	    <xsl:text>&#13;{</xsl:text> 
		<xsl:apply-templates select="../viewmodel/savecascades" mode="cascades-set" />
	    <xsl:text>&#13;}</xsl:text>  -->
	    ChainedActionArgs parameterOut = base.DoAction(parameterListIn, context, actionQualifier, dispacher);
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">PostSaveTreatment</xsl:with-param>
		</xsl:call-template>
	
	    return (parameterOut);
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	 public override void DoOnFailed(ChainedActionArgs parameterListOut, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">DoOnFailedSave</xsl:with-param>
	    </xsl:call-template>
	    
	    base.DoOnFailed(parameterListOut, context, actionQualifier, dispacher);
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	 public override void DoOnSuccess(ChainedActionArgs parameterListOut, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">DoOnSuccessSave</xsl:with-param>
	   	</xsl:call-template>
	   	
	   	base.DoOnSuccess(parameterListOut, context, actionQualifier, dispacher);
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	<xsl:text>public override void CompleteNewEntity(</xsl:text>
	<xsl:choose>
		<xsl:when test="/action/chained-action">
			<xsl:text>IMIdentifiable</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="/action/class/implements/interface/@name"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text> entity, IViewModel viewmodel, IMFContext context)</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>base.CompleteNewEntity(entity, viewmodel, context);</xsl:text>
	<xsl:apply-templates select="../class/association[@type='many-to-one']" mode="generate-method-call-completenewentity"/>
	<xsl:text>}&#13;</xsl:text>
	
	<xsl:apply-templates select="../class/association[@type='many-to-one']" mode="generate-method-completenewentity"/>
	
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template> 
	
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	<xsl:text>&#13;}&#13;</xsl:text>
</xsl:template>


<xsl:template match="action-type[. ='DELETEDETAIL']" mode="action-chained-impl">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Class DeleteChained</xsl:text><xsl:value-of select="../chained-action"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>public class DeleteChained</xsl:text><xsl:value-of select="../chained-action"/>
	<xsl:text> : DeleteChainAction&lt;IMIdentifiable&gt;, IDeleteChained</xsl:text><xsl:value-of select="../chained-action"/>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>&#13;#region Methods&#13;</xsl:text>
	<xsl:text>/// &lt;inheritDoc /&gt;</xsl:text>       
	public override ChainedActionArgs DoAction(ChainedActionArgs parameterListIn, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">PreDeleteTreatment</xsl:with-param>
		</xsl:call-template>
	    <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">GenericDeleteAction</xsl:with-param>
		</xsl:call-template>
		
	    ChainedActionArgs parameterOut = base.DoAction(parameterListIn, context, actionQualifier, dispacher);
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">PostDeleteTreatment</xsl:with-param>
		</xsl:call-template>
	
	    return (parameterOut);
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	 public override void DoOnFailed(ChainedActionArgs parameterListOut, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">DoOnFailedDelete</xsl:with-param>
	    </xsl:call-template>
	    
	    base.DoOnFailed(parameterListOut, context, actionQualifier, dispacher);
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	 public override void DoOnSuccess(ChainedActionArgs parameterListOut, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">DoOnSuccessDelete</xsl:with-param>
	   	</xsl:call-template>
	   	
	   	base.DoOnSuccess(parameterListOut, context, actionQualifier, dispacher);
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	<xsl:text>public override void CompleteNewEntity(</xsl:text>
	<xsl:choose>
		<xsl:when test="/action/chained-action">
			<xsl:text>IMIdentifiable</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="/action/class/implements/interface/@name"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text> entity, IViewModel viewmodel, IMFContext context)</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>base.CompleteNewEntity(entity, viewmodel, context);</xsl:text>
	<xsl:apply-templates select="../class/association[@type='many-to-one']" mode="generate-method-call-completenewentity"/>
	<xsl:text>}&#13;</xsl:text>
	
	<xsl:apply-templates select="../class/association[@type='many-to-one']" mode="generate-method-completenewentity"/>
	
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template> 
	
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	<xsl:text>&#13;}&#13;</xsl:text>
</xsl:template>


<xsl:template match="action-type[. ='DELETEDETAIL']" mode="action-impl">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Class </xsl:text><xsl:value-of select="../name"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>public class </xsl:text><xsl:value-of select="../name"/>
	<xsl:text> : DeleteAction&lt;</xsl:text><xsl:value-of select="../class/implements/interface/@name"/><xsl:text>,</xsl:text><xsl:value-of select="../dao-interface/name"/><xsl:text>&gt;, </xsl:text><xsl:value-of select="../implements/interface/@name"/>
	<xsl:text>{</xsl:text>
	<xsl:text>&#13;#region Methods&#13;</xsl:text>
	public override CUDActionArgs DoAction(CUDActionArgs parameterIn, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">PreDeleteTreatment</xsl:with-param>
		</xsl:call-template>
	    <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">GenericDeleteAction</xsl:with-param>
		</xsl:call-template>
		
			<!-- <xsl:apply-templates select="../viewmodel/savecascades" mode="cascades-set" /> -->
	      	CUDActionArgs parameterOut = base.DoAction(parameterIn, context, actionQualifier, dispacher);
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">PostDeleteTreatment</xsl:with-param>
		</xsl:call-template>
	
	       return (parameterOut);
	}
	
	 public override CascadeSet GetDeleteCascadeSet()
	    {
	        <xsl:text>return </xsl:text><xsl:apply-templates select="../dao-interface/dao/delete-cascade" mode="cascades-set" /><xsl:text>;</xsl:text>
	    }
	
	 public override void DoOnFailed(CUDActionArgs parameterOut, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">DoOnFailedDelete</xsl:with-param>
	    </xsl:call-template>
	    
	    base.DoOnFailed(parameterOut, context, actionQualifier, dispacher);
	}
	
	 public override void DoOnSuccess(CUDActionArgs parameterOut, IMFContext context, IActionQualify actionQualifier, IActionProgressDispacher dispacher)
	{
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">DoOnSuccessDelete</xsl:with-param>
	    </xsl:call-template>
	    
	    base.DoOnSuccess(parameterOut, context, actionQualifier, dispacher);
	}
	
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template> 
	
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	
	<xsl:text>&#13;}&#13;</xsl:text>
</xsl:template>


<xsl:template match="savecascades" mode="cascades-set">
	<xsl:choose>
		<xsl:when test="count(cascade) > 0">
		<xsl:text>CascadeSet.Of(</xsl:text>
		<xsl:apply-templates select="cascade" mode="cascade-set" />
		<xsl:text>)</xsl:text>
		</xsl:when>
		<xsl:otherwise>
		<xsl:text>CascadeSet.NONE</xsl:text>		
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="delete-cascade" mode="cascades-set">
	<xsl:choose>
		<xsl:when test="count(cascade) > 0">
		<xsl:text>CascadeSet.Of(</xsl:text>
		<xsl:apply-templates select="cascade" mode="delete-cascade-set" />
		<xsl:text>)</xsl:text>
		</xsl:when>
		<xsl:otherwise>
		<xsl:text>CascadeSet.NONE</xsl:text>		
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="cascade" mode="cascade-set">
	<xsl:value-of select="."/>
	<xsl:if test="position() != count(../cascade)">
		<xsl:text>, </xsl:text>
	</xsl:if>
</xsl:template>


<xsl:template match="cascade" mode="delete-cascade-set">
	<xsl:value-of select="./entity-name"/><xsl:text>Cascade.</xsl:text><xsl:value-of select="@name"/>
	<xsl:if test="position() != count(../cascade)">
		<xsl:text>, </xsl:text>
	</xsl:if>
</xsl:template>


<xsl:template match="association[@transient='false']" mode="generate-method-call-completenewentity">

	<xsl:text>CompleteEntity</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>(</xsl:text>
	<xsl:text>entity, viewmodel, context);&#13;</xsl:text>

</xsl:template>

<xsl:template match="association[@transient='true']" mode="generate-method-call-completenewentity">
</xsl:template>

<xsl:template match="association[@transient='false']" mode="generate-method-completenewentity">

	<xsl:text>public void CompleteEntity</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>(</xsl:text>
	<xsl:choose>
		<xsl:when test="/action/chained-action">
			<xsl:text>IMIdentifiable</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="/action/class/implements/interface/@name"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text> entity, IViewModel viewmodel, IMFContext context)</xsl:text>
	<xsl:text>{&#13;</xsl:text>

	<xsl:value-of select="dao-interface/name"/><xsl:text> oDao</xsl:text><xsl:value-of select="dao-interface/name"/>
	<xsl:text> = ClassLoader.GetInstance().GetBean&lt;</xsl:text><xsl:value-of select="dao-interface/name"/><xsl:text>&gt;();</xsl:text>
	<xsl:value-of select="interface/name"/><xsl:text> parent</xsl:text><xsl:value-of select="interface/name"/>
	<xsl:text> = oDao</xsl:text><xsl:value-of select="dao-interface/name"/><xsl:text>.Get</xsl:text><xsl:value-of select="class/name"/>
	<xsl:text>(((IMFIsChildItem)viewmodel).IdParent, context);</xsl:text>
	<xsl:if test="/action/chained-action">
		<xsl:text>((</xsl:text><xsl:value-of select="../implements/interface/@name"/><xsl:text>)</xsl:text>
	</xsl:if>
	<xsl:text>entity</xsl:text>
	<xsl:if test="/action/chained-action">
		<xsl:text>)</xsl:text>
	</xsl:if>
	<xsl:text>.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text> = parent</xsl:text>
	<xsl:value-of select="interface/name"/><xsl:text>;&#13;&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>

</xsl:template>

<xsl:template match="association[@transient='true']" mode="generate-method-completenewentity">
</xsl:template>

</xsl:stylesheet>