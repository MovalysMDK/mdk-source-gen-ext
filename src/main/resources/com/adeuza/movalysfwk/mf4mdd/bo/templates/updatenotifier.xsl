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

<xsl:output method="text"/>	

<xsl:template match="class">
<xsl:text>package </xsl:text><xsl:value-of select="package"/>;

<xsl:variable name="interface" select="implements/interface"/>

<xsl:for-each select="import">
<xsl:sort select="."/>
<xsl:text>import </xsl:text><xsl:value-of select="."/><xsl:text> ;
</xsl:text>
</xsl:for-each>

import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.annotations.Public ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.CascadeSet;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.changes.AbstractEntityUpdateNotifier ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.changes.NotifySession;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.changes.UpdateListener;

import java.util.List ;
import java.util.Map ;

/**
 * &lt;p&gt;Notifie des changements sur un objet <xsl:value-of select="implements/interface/@name"/>&lt;/p&gt;
 *
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Copyright (c) 2010</p>]]></xsl:text>
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Company: Adeuza</p>]]></xsl:text>
 *
 */ 
@Public
public class <xsl:value-of select="implements/interface/@name"/>
	<xsl:text>UpdateNotifier extends AbstractEntityUpdateNotifier&lt;</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text>&gt; {</xsl:text>

	/**
	 * Contructeur
	 */
	@Public	 
	public <xsl:value-of select="implements/interface/@name"/>UpdateNotifier() {
		super();
	}

	/**
	 * Contructeur
	 *
	 * @param p_mapUpdateListeners listeners à utiliser pour la notification
	 */
	@Public	 
	public <xsl:value-of select="implements/interface/@name"/>UpdateNotifier( Map&lt;String,List&lt;UpdateListener&gt;&gt; p_mapUpdateListeners ) {
		super(p_mapUpdateListeners);
	}

	/**
	 * {@inheritDoc}
	 *
	 * @see com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.changes.UpdateNotifier#notifyUpdates(com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.MEntity, com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.MEntity)
	 */
	@Override
	@Public	
	public void notifyUpdates(<xsl:value-of select="$interface/@name"/> 
			<xsl:text> p_o</xsl:text>
			<xsl:value-of select="$interface/@name"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="$interface/@name"/>
			<xsl:text> p_oOld</xsl:text>
			<xsl:value-of select="$interface/@name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, NotifySession p_oNotifySession ) throws Exception {
	</xsl:text>
			
		if( p_oNotifySession.getFromCache(<xsl:value-of select="$interface/@name"/>
			<xsl:text>.ENTITY_NAME, p_o</xsl:text>
			<xsl:value-of select="$interface/@name"/>.idToString()) == null) {
			p_oNotifySession.addToCache(<xsl:value-of select="$interface/@name"/>
			<xsl:text>.ENTITY_NAME, p_o</xsl:text>
			<xsl:value-of select="$interface/@name"/>
			<xsl:text>.idToString(), p_o</xsl:text>
			<xsl:value-of select="$interface/@name"/><xsl:text> );
			</xsl:text>

			<!-- pour chaque attribut -->
			<xsl:for-each select="//*[(name() = 'attribute' and not(parent::association))]">
			
				<xsl:text>if (p_o</xsl:text>
				<xsl:value-of select="$interface/@name"/>
				<xsl:text>.isAttributeUpdated(</xsl:text>
				<xsl:value-of select="$interface/@name"/>
				<xsl:text>.ATTRIBUTES.</xsl:text><xsl:value-of select="@name-uppercase"/><xsl:text>)) {</xsl:text>
					callOnChange(<xsl:value-of select="$interface/@name"/>
					<xsl:text>.ENTITY_NAME, "onChange</xsl:text>
					<xsl:value-of select="method-crit-name"/>
					<xsl:text>", </xsl:text>
					<xsl:value-of select="$interface/@name"/>
					<xsl:text>.class, p_o</xsl:text>
					<xsl:value-of select="$interface/@name"/>
					<xsl:text>, p_oOld</xsl:text>
					<xsl:value-of select="$interface/@name"/>
					<xsl:text>);</xsl:text>
				}
			</xsl:for-each>
			
			<!-- champs dynamique -->
			/*DISABLED IN BACKPORT
			if (!p_oCascadeSet.contains(CascadeSet.GenericCascade.NOT_ALL_DYN) 
				<xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> !p_oCascadeSet.contains(<xsl:value-of select="$interface/@name"/>.Cascade.NOT_DYN)) {
				for( String sDynamicalFieldName: p_o<xsl:value-of select="$interface/@name"/>.getMapDynamicalField().keySet()) {
					if ( p_o<xsl:value-of select="$interface/@name"/>.isDynamicalFieldUpdated(sDynamicalFieldName)) {
						callOnChange(<xsl:value-of select="$interface/@name"/>.ENTITY_NAME, "onChange" + sDynamicalFieldName.substring(0,1).toUpperCase()
							+ sDynamicalFieldName.substring(1), <xsl:value-of select="$interface/@name"/>.class, p_o<xsl:value-of select="$interface/@name"/>,
						p_oOld<xsl:value-of select="$interface/@name"/>);
					}
				}
				for (String sDynamicalFieldName : p_o<xsl:value-of select="$interface/@name"/>.getMapDynamicalField().getAddedElements()) {					
					callOnChange(<xsl:value-of select="$interface/@name"/>.ENTITY_NAME, "onAddDynamicalField" + sDynamicalFieldName.substring(0,1).toUpperCase()
							+ sDynamicalFieldName.substring(1),	<xsl:value-of select="$interface/@name"/>.class,
							p_o<xsl:value-of select="$interface/@name"/>, p_oOld<xsl:value-of select="$interface/@name"/>);
				}
				
				for (String sDynamicalFieldName : p_o<xsl:value-of select="$interface/@name"/>.getMapDynamicalField().getRemovedElements()) {					
					callOnChange(<xsl:value-of select="$interface/@name"/>.ENTITY_NAME, "onRemoveDynamicalField" + sDynamicalFieldName.substring(0,1).toUpperCase()
							+ sDynamicalFieldName.substring(1), <xsl:value-of select="$interface/@name"/>.class,
							p_o<xsl:value-of select="$interface/@name"/>, p_oOld<xsl:value-of select="$interface/@name"/>);
				}
			}
			*/			
			
			<!-- Pour chaque relation many-to-one et one-to-one -->
			<xsl:for-each 
				select="//*[(name()= 'association' and  (@type='many-to-one' or @type='one-to-one') and not(parent::association))]">
			if (p_o<xsl:value-of select="$interface/@name"/>.isAttributeUpdated(<xsl:value-of select="$interface/@name"/>
				<xsl:text>.ATTRIBUTES.</xsl:text>
				<xsl:value-of select="@cascade-name"/>
				<xsl:text>)) {</xsl:text>
				
				<xsl:value-of select="interface/name"/> oOld<xsl:value-of select="interface/name"/> = null ;
				if ( p_oOld<xsl:value-of select="$interface/@name"/> != null ) {
					oOld<xsl:value-of select="interface/name"/>
					<xsl:text> = p_oOld</xsl:text>
					<xsl:value-of select="$interface/@name"/>
					<xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/>();
				}
				
				if ( p_o<xsl:value-of select="$interface/@name"/>.<xsl:value-of select="get-accessor"/>() != null ) {
					callOnChange(<xsl:value-of select="$interface/@name"/>
					<xsl:text>.ENTITY_NAME, "onChange</xsl:text>
					<xsl:value-of select="@name-capitalized"/>
					<xsl:text>", </xsl:text>
					<xsl:value-of select="interface/name"/>
					<xsl:text>.class, p_o</xsl:text>
					<xsl:value-of select="$interface/@name"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="get-accessor"/>
					<xsl:text>(), oOld</xsl:text><xsl:value-of select="interface/name"/>
					<xsl:text> );</xsl:text>
				}
				else {
					callOnChange(<xsl:value-of select="$interface/@name"/>
					<xsl:text>.ENTITY_NAME, "onRemove</xsl:text>
					<xsl:value-of select="@name-capitalized"/>
					<xsl:text>", </xsl:text>
					<xsl:value-of select="interface/name"/>
					<xsl:text>.class, p_o</xsl:text>
					<xsl:value-of select="$interface/@name"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="get-accessor"/>
					<xsl:text>(), oOld</xsl:text><xsl:value-of select="interface/name"/>
					<xsl:text> );</xsl:text>
				}
			}
			
			if (( p_oCascadeSet.contains( <xsl:value-of select="$interface/@name"/>.Cascade.<xsl:value-of select="@cascade-name"/>
				<xsl:text> ) || p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL)) &amp;&amp; p_o</xsl:text>
				<xsl:value-of select="$interface/@name"/><xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/>() != null ) {
				<xsl:value-of select="interface/name"/>
				<xsl:text>UpdateNotifier o</xsl:text>
				<xsl:value-of select="interface/name"/>
				<xsl:text>UpdateNotifier = new </xsl:text>
				<xsl:value-of select="interface/name"/>
				<xsl:text>UpdateNotifier(this.mapListeners);</xsl:text>
				
				<xsl:value-of select="interface/name"/> oOld<xsl:value-of select="interface/name"/> = null ;
				if ( p_oOld<xsl:value-of select="$interface/@name"/> != null) {
					oOld<xsl:value-of select="interface/name"/>
					<xsl:text> = p_oOld</xsl:text>
					<xsl:value-of select="$interface/@name"/>
					<xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/>();
				}
				
				<xsl:text>o</xsl:text>
				<xsl:value-of select="interface/name"/>
				<xsl:text>UpdateNotifier.notifyUpdates(p_o</xsl:text>
				<xsl:value-of select="$interface/@name"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="get-accessor"/>
				<xsl:text>(), oOld</xsl:text><xsl:value-of select="interface/name"/>
				<xsl:text>, p_oCascadeSet, p_oNotifySession );</xsl:text>
			}
			</xsl:for-each>
			
			<!-- Pour chaque relation one-to-many et many-to-many -->
			<xsl:for-each select="//*[(name()= 'association' and  (@type='one-to-many' or @type='many-to-many')) and not(parent::association)]">
			
			<xsl:text>if ( p_o</xsl:text><xsl:value-of select="$interface/@name"/>
				<xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/>
				<xsl:text>() != null ) {</xsl:text> 
			<xsl:text>for (</xsl:text>
			<xsl:value-of select="interface/name"/>
			<xsl:text> oAdded</xsl:text>
			<xsl:value-of select="interface/name"/>
			<xsl:text> : p_o</xsl:text>
			<xsl:value-of select="$interface/@name"/>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="get-accessor"/>
			<xsl:text>().getAddedElements()) {
			</xsl:text>
				callOnChange(<xsl:value-of select="$interface/@name"/>
				<xsl:text>.ENTITY_NAME, "onAdded</xsl:text><xsl:value-of select="@name-capitalized"/>
				<xsl:text>", </xsl:text>
				<xsl:value-of select="interface/name"/>
				<xsl:text>.class, oAdded</xsl:text>
				<xsl:value-of select="interface/name"/>
				<xsl:text>);</xsl:text>
			}
			}

			<xsl:text>if ( p_o</xsl:text><xsl:value-of select="$interface/@name"/>
					<xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/>
					<xsl:text>() != null ) {</xsl:text> 
			for (<xsl:value-of select="interface/name"/>
			<xsl:text> oRemoved</xsl:text>
			<xsl:value-of select="interface/name"/>
			<xsl:text> : p_o</xsl:text>
			<xsl:value-of select="$interface/@name"/>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="get-accessor"/>
			<xsl:text>().getRemovedElements()) {</xsl:text>
				callOnChange(<xsl:value-of select="$interface/@name"/>
				<xsl:text>.ENTITY_NAME, "onRemoved</xsl:text>
				<xsl:value-of select="@name-capitalized"/>
				<xsl:text>", </xsl:text>
				<xsl:value-of select="interface/name"/>
				<xsl:text>.class, oRemoved</xsl:text>
				<xsl:value-of select="interface/name"/>
				<xsl:text>);</xsl:text>
			}
			}

			if (( p_oCascadeSet.contains( <xsl:value-of select="$interface/@name"/>.Cascade.<xsl:value-of select="@cascade-name"/>
					<xsl:text>) || p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL)) &amp;&amp; p_o</xsl:text>
					<xsl:value-of select="$interface/@name"/>
					<xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>() != null ) {</xsl:text>
				<xsl:value-of select="interface/name"/>
				<xsl:text>UpdateNotifier o</xsl:text><xsl:value-of select="interface/name"/>
				<xsl:text>UpdateNotifier = new </xsl:text>
				<xsl:value-of select="interface/name"/>
				<xsl:text>UpdateNotifier(this.mapListeners);</xsl:text>
				for (<xsl:value-of select="interface/name"/><xsl:text> o</xsl:text><xsl:value-of select="interface/name"/>
					<xsl:text> : p_o</xsl:text><xsl:value-of select="$interface/@name"/><xsl:text>.</xsl:text>
					<xsl:value-of select="get-accessor"/><xsl:text>()) {</xsl:text>
					<xsl:value-of select="interface/name"/><xsl:text> oOld</xsl:text><xsl:value-of select="interface/name"/><xsl:text> = null ;
					if ( p_oOld</xsl:text><xsl:value-of select="$interface/@name"/>
						<xsl:text> != null &amp;&amp; p_oOld</xsl:text>
						<xsl:value-of select="$interface/@name"/>.<xsl:value-of select="get-accessor"/>() != null ) {
						<xsl:text> oOld</xsl:text><xsl:value-of select="interface/name"/>
					<xsl:text> = p_oOld</xsl:text><xsl:value-of select="$interface/@name"/>.<xsl:value-of select="get-accessor"/>
					<xsl:text>().getById(o</xsl:text>
					<xsl:value-of select="interface/name"/>
					<xsl:text>.idToString());</xsl:text>
					}
					<xsl:text>o</xsl:text>
					<xsl:value-of select="interface/name"/>
					<xsl:text>UpdateNotifier.notifyUpdates(o</xsl:text>
					<xsl:value-of select="interface/name"/>
					<xsl:text>, oOld</xsl:text>
					<xsl:value-of select="interface/name"/>
					<xsl:text>, p_oCascadeSet, p_oNotifySession );</xsl:text>
				}
			}
			</xsl:for-each>
		}
	}
}

</xsl:template>
</xsl:stylesheet>