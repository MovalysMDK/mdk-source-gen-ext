/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.mbandroid.mupdater;

import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.mupdater.AbstractMUpdater;
import com.a2a.adjava.uml.UmlAssociationEnd.AggregateType;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAssociation;
import com.a2a.adjava.xmodele.MAssociation.AssociationType;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MEntityImpl;

/**
 * Pour les relations de type "ToOne" et de type Aggregation, ajoute des attributs primitifs
 * transients dans l'objet source pour contenir la valeur de la FK.
 * Ces attributs transients sont utilisés pour la serialization Json de la synchro.
 * @author lmichenaud
 */
public class AddTranscientIdForFK extends AbstractMUpdater {

	private static Logger log = LoggerFactory.getLogger(AddTranscientIdForFK.class);
	
	/**
	 * (non-Javadoc)
	 * @see com.a2a.adjava.mupdater.MUpdater#execute(com.a2a.adjava.xmodele.XDomain, java.util.Map)
	 */
	public void execute(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		
		boolean bTranscient = true;
		
		for (MEntityImpl oEntityImpl : p_oDomain.getDictionnary().getAllEntities()) {
		
			for( MAssociation oAssociation : oEntityImpl.getAssociations()) {
				
				if (( oAssociation.getAssociationType().equals(AssociationType.MANY_TO_ONE)
						|| oAssociation.getAssociationType().equals(AssociationType.ONE_TO_ONE))
					 && oAssociation.getOppositeAggregateType() == AggregateType.AGGREGATE
					 && oAssociation.getOppositeClass().getIdentifier().isComposite() == false 
					 && oAssociation.getOppositeClass().getIdentifier().getElemOfTypeAttribute().size() == 1 ) {
					
					MAttribute oAttr = oAssociation.getRefClass().getIdentifier().getElemOfTypeAttribute().get(0);

					String sAttrName = oAssociation.getName() + StringUtils.capitalize(oAttr.getName());

					MAttribute oNewAttr = p_oDomain.getXModeleFactory().createMAttribute(sAttrName, "private",
							false, false, bTranscient, oAttr.getTypeDesc(), oAttr.getDocumentation());
					oNewAttr.setInitialisation(oAttr.getInitialisation());
					oNewAttr.addParameter("fkidholder", "true");
					oNewAttr.addParameter("fkidholder-assoname", oAssociation.getName());
					
					oAssociation.addAnnotation(AddOldIdUpdater.unexposedAnnotation);
					
					oEntityImpl.addAttribute(oNewAttr);
					oEntityImpl.addImport(AddOldIdUpdater.unexposedAnnotation.getFullName());
				}
			}
		}
	}
}
